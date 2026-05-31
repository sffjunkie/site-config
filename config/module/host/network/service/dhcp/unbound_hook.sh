#!/usr/bin/env sh
# https://github.com/opnsense/core/issues/7475

# Kea DHCPv4 Unbound DNS Hook Script
#
# This script dynamically updates Unbound DNS with DHCP lease information from Kea DHCP.
# Features:
#   - Adds A and PTR records to Unbound for active DHCP leases
#   - Honors per-subnet domain-name configured in Kea
#   - Falls back to system hostname domain or 'home.arpa' if no subnet domain is configured
#   - Avoids conflicts with statically defined zones in host_entries.conf
#   - Performs deduplication of entries in the lease file
#   - Sends dynamic DNS updates via unbound-control
#   - Full debug/info logging via syslog (local4 facility)

LOG_TAG="kea-unbound-hook"
LEASES_FILE="/var/unbound/dhcpleases.conf"
TMP_FILE="$LEASES_FILE.tmp"
HOST_ENTRIES="/var/unbound/host_entries.conf"
UNBOUND_CONF="/var/unbound/unbound.conf"
KEA_CTRL_CONF="/usr/local/etc/kea/kea-ctrl-agent.conf"

# Log to syslog or stderr fallback
log() {
  LEVEL="$1"
  MSG="$2"
  if [ "$LEVEL" = "debug" ]; then
    logger -t "kea-dhcp4" -p local4.debug "$LOG_TAG: $MSG" 2>/dev/null || echo "$LOG_TAG: $MSG" >&2
  else
    logger -t "kea-dhcp4" -p local4.info "$LOG_TAG: $MSG" 2>/dev/null || echo "$LOG_TAG: $MSG" >&2
  fi
}

# Get Kea Control Agent URL
get_ca_url() {
  jq -r '"http://" + ."Control-agent"."http-host" + ":" + (."Control-agent"."http-port"|tostring)' "$KEA_CTRL_CONF" 2>/dev/null
}

# Normalize hostname: lowercase, strip domain, remove non-DNS characters
normalize_hostname() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/\..*//' | sed 's/[^a-z0-9-]//g'
}

# Resolve subnet-specific domain name for an IP
get_domain_for_ip() {
  IP="$1"
  CA_URL=$(get_ca_url)
  [ -z "$CA_URL" ] && { log info "get_domain_for_ip: No CA_URL"; echo ""; return; }
  OUTPUT=$(curl -s -X POST "$CA_URL" -H 'Content-Type: application/json' \
    -d '{"command": "lease4-get", "arguments": {"ip-address": "'"$IP"'"}, "service": ["dhcp4"]}')
  SUBNET_ID=$(echo "$OUTPUT" | jq -r '.[0].arguments["subnet-id"]')
  [ -z "$SUBNET_ID" ] && { log debug "get_domain_for_ip: No subnet-id for $IP"; echo ""; return; }

  CONFIG=$(curl -s -X POST "$CA_URL" -H 'Content-Type: application/json' \
    -d '{"command": "config-get", "service": ["dhcp4"]}')
  DOMAIN=$(echo "$CONFIG" | jq -r --arg id "$SUBNET_ID" '.[] | .arguments.Dhcp4.subnet4[] | select(.id == ($id|tonumber)) | ."option-data"[]? | select(.name == "domain-name") | .data')
  DOMAIN=$(echo "$DOMAIN" | tr -d '\n\r' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9.-]//g')
  [ -n "$DOMAIN" ] && { log debug "get_domain_for_ip: $IP -> $DOMAIN"; echo "$DOMAIN"; } || echo ""
}

# Check if zone is statically configured
in_host_entries_conf() {
  ZONE="$1"
  [ ! -f "$HOST_ENTRIES" ] && return 1
  grep -q "local-zone: \"$ZONE\" transparent" "$HOST_ENTRIES" && return 0 || return 1
}

# Register a zone with Unbound unless static
add_local_zone() {
  ZONE="$1"
  [ -z "$ZONE" ] && return
  echo "$ZONE" | grep -q '[^a-z0-9.-]' && return
  in_host_entries_conf "$ZONE" && { log debug "add_local_zone: Zone $ZONE is static in host_entries.conf, skipping"; return; }
  grep -q "local-zone: \"$ZONE\" transparent" "$TMP_FILE" 2>/dev/null || \
    echo "local-zone: \"$ZONE\" transparent" >> "$TMP_FILE"
  unbound-control -c "$UNBOUND_CONF" local_zone "$ZONE" transparent >/dev/null 2>&1 || \
    { log info "add_local_zone: local_zone failed, reloading Unbound"; service unbound reload >/dev/null 2>&1 || service unbound restart >/dev/null 2>&1; }
  log debug "add_local_zone: Zone $ZONE added dynamically"
}

# Add A and PTR record for a lease
add_dns_entry() {
  IP="$1"
  NAME="$2"
  DOMAIN="$3"
  FQDN="$NAME.$DOMAIN"

  sed -i '' "/${IP}[[:space:]]/d" "$TMP_FILE" 2>/dev/null
  sed -i '' "/$FQDN IN A/d" "$TMP_FILE" 2>/dev/null

  echo "local-data: \"$FQDN IN A $IP\"" >> "$TMP_FILE"
  echo "local-data-ptr: \"$IP $FQDN\"" >> "$TMP_FILE"

  unbound-control -c "$UNBOUND_CONF" local_data_remove "$FQDN" >/dev/null 2>&1
  unbound-control -c "$UNBOUND_CONF" local_data "$FQDN IN A $IP" >/dev/null 2>&1 && \
    log debug "add_dns_entry: Added A $FQDN -> $IP"

  unbound-control -c "$UNBOUND_CONF" local_data_remove "$IP" >/dev/null 2>&1
  unbound-control -c "$UNBOUND_CONF" local_data "$IP PTR $FQDN" >/dev/null 2>&1 && \
    log debug "add_dns_entry: Added PTR $IP -> $FQDN"

  add_local_zone "$DOMAIN"
}

# Handle new or renewed leases
leases4_committed() {
  log debug "leases4_committed: Starting with LEASES4_SIZE=$LEASES4_SIZE"
  [ -z "$LEASES4_SIZE" ] || [ "$LEASES4_SIZE" -lt 1 ] && return

  # shellcheck disable=SC2188
  cp "$LEASES_FILE" "$TMP_FILE" 2>/dev/null || > "$TMP_FILE"

  i=0
  while [ "$i" -lt "$LEASES4_SIZE" ]; do
    IP=$(eval echo \$LEASES4_AT${i}_ADDRESS)
    HOST=$(eval echo \$LEASES4_AT${i}_HOSTNAME)
    MAC=$(eval echo \$LEASES4_AT${i}_HWADDR)

    log debug "leases4_committed: Lease $i: IP=$IP, HOST=$HOST, MAC=$MAC"
    [ -z "$IP" ] && { log debug "leases4_committed: Lease $i missing IP, skipping"; i=$((i + 1)); continue; }

    DOMAIN=$(get_domain_for_ip "$IP")
    [ -z "$DOMAIN" ] && DOMAIN=$(hostname -d 2>/dev/null)
    [ -z "$DOMAIN" ] && DOMAIN="home.arpa"

    [ -z "$HOST" ] && HOST="device-$(echo "$MAC" | tr ':' '-')"
    HOST=$(normalize_hostname "$HOST")
    if [ -z "$HOST" ]; then
      HOST="device-$(echo "$MAC" | tr ':' '-')"
      log debug "normalize_hostname: Normalization failed, fallback to $HOST"
    fi

    FQDN="$HOST.$DOMAIN"
    add_dns_entry "$IP" "$HOST" "$DOMAIN"

    i=$((i + 1))
  done

  sort -u "$TMP_FILE" > "$LEASES_FILE"
  rm -f "$TMP_FILE"

  FLAT_CONTENTS=$(cat "$LEASES_FILE" | tr '\n' ' ' | sed 's/  */ /g')
  log debug "leases4_committed: Final file contents: $FLAT_CONTENTS"
  log info "leases4_committed: Updated $LEASES_FILE"
}

# Hook dispatch
case "$1" in
  leases4_committed|lease4_renew) leases4_committed ;;
  lease4_release|lease4_expire|lease4_decline)
    IP="$LEASE4_ADDRESS"
    log debug "remove_dns_entry: Removing entries for IP $IP"
    unbound-control -c "$UNBOUND_CONF" local_data_remove "$IP" >/dev/null 2>&1
    sed -i '' "/${IP}[[:space:]]/d" "$LEASES_FILE" 2>/dev/null
    ;;
  *) log debug "Unhandled hook: $1" ;;
esac

exit 0

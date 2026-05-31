{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.network.firewall;
  wanIf = "wan0";
  lanIf = "lan0";
  guestIf = "guest@lan0";
  iotIf = "iot@lan0";
  notIf = "not@lan0";

  wgPort = lib.looniversity.network.serviceHandlerMainPort config "wireguard";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.network.firewall = {
    enable = mkEnableOption "Firewall";
  };

  config = mkIf cfg.enable {
    networking = {
      nftables = {
        enable = true;
        tables = {
          nat = {
            family = "ip";
            content = ''
              chain prerouting {
                  type nat hook prerouting priority filter; policy accept;
                  # Intercept DNS queries and make sure they get redirected to the router's DNS
                  iifname {"${guestIf}", "${iotIf}", "${notIf}", "${lanIf}"} udp dport 53 counter redirect to 53
                  iifname {"${guestIf}", "${iotIf}", "${notIf}", "${lanIf}"} tcp dport 53 counter redirect to 53
                }

                chain postrouting {
                  type nat hook postrouting priority 100; policy accept;
                  oifname ${wanIf} masquerade
                }
            '';
          };
          global = {
            family = "inet";
            content = ''
              chain inbound_world {
                  # Enable ICMPv6 types necessary for DHCPv6
                  ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, mld-listener-query, nd-router-solicit } accept
                  # Allow port 546/udp for DHCPv6
                  ip6 saddr fe80::/10 iifname ${wanIf} udp sport 547 udp dport 546 accept

                  # Allow Wireguard
                  udp dport ${wgPort} accept

                  counter drop
                }

                chain inbound_untrusted {
                  icmp type echo-request limit rate 5/second accept
                  ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, mld-listener-query, nd-router-solicit } accept

                  # Allow DNS and DHCP on untrusted networks (iot, guest)
                  udp dport 53 accept
                  udp dport 546 accept
                  tcp dport 53 accept
                  udp dport 67 accept

                  counter drop
                }

                chain inbound {
                  type filter hook input priority 0; policy drop;

                  # Allow traffic from established and related packets, drop invalid
                  ct state vmap { established : accept, related : accept, invalid : drop }

                  iifname vmap { lo : accept, wg0 : accept, ${wanIf} : jump inbound_world, ${lanIf} : accept, tailscale0 : accept, ${guestIf} : jump inbound_untrusted, ${iotIf} : jump inbound_untrusted }
                }

                chain forward {
                  type filter hook forward priority 0; policy drop;

                  ct state vmap { established : accept, related : accept, invalid : drop }

                  iifname {"${lanIf}", "tailscale0", "wg0""} accept
                  iifname ${guestIf} oifname ${wanIf} accept

                  counter drop
                }

                chain prerouting {
                  type nat hook prerouting priority filter; policy accept;

                }
            '';
          };
        };
      };
    };
  };
}

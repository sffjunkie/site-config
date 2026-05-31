{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.network.service.dhcp;
  inherit (config.looniversity.network) vlans;
  vlanDHCP = map (
    name:
    let
      vlanInfo = vlans.${name};

      vlanNetwork = lib.looniversity.ipv4.constructIpv4Address config.looniversity.network.networkAddress "${toString vlanInfo.id}.0";

      vlanPoolStart = lib.looniversity.ipv4.constructIpv4Address vlanNetwork (
        toString vlanInfo.dhcp_start
      );

      vlanPoolEnd = lib.looniversity.ipv4.constructIpv4Address vlanNetwork (toString vlanInfo.dhcp_end);
    in
    {
      inherit (vlanInfo) id;
      subnet = lib.concatStringsSep "/" [
        vlanNetwork
        (toString vlanInfo.prefixLength)
      ];

      pools = [
        {
          pool = "${vlanPoolStart} - ${vlanPoolEnd}";
        }
      ];
    }
  ) (lib.attrNames vlans);

  keaHooksPath = "${pkgs.kea}/lib/kea/hooks";

  unboundUpdate = pkgs.writeShellScriptBin {
    name = "unbound_hook.sh";
    text = builtins.readFile ./unbound_hook.sh;
  };

  dynamicLeasesHook = [
    {
      library = "${keaHooksPath}/libdhcp_run_script.so";
      parameters = {
        name = "${unboundUpdate}";
        sync = false;
      };
    }
  ];

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  inherit (lib.looniversity.ipv4) constructIpv4Address;
in
{
  options.looniversity.network.service.dhcp = {
    enable = mkEnableOption "dhcp";

    registerDynamicLeases = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.kea = {
      dhcp4 = {
        enable = true;

        settings = {
          authoritative = true;
          valid-lifetime = 7200;
          max-valid-lifetime = 86400;

          lease-database = {
            type = "memfile";
            persist = true;
            name = "/var/lib/kea/dhcp4.leases";
          };

          option-data = [
            {
              name = "domain-name";
              data = config.looniversity.network.domainName;
            }
            {
              name = "domain-name-servers";
              data = lib.concatStringsSep ", " (
                config.looniversity.network.nameServers ++ config.looniversity.network.extraNameServers
              );
            }
            {
              name = "routers";
              data = "10.44.0.1";
            }
          ];

          loggers = [
            {
              name = "kea-dhcp4";
              output_options = [
                {
                  output = "syslog";
                }
              ];
              severity = "INFO";
            }
          ];

          control-socket = {
            socket-type = "unix";
            socket-name = "/run/kea/kea4-ctrl-socket";
          };

          hooks-libraries = [
            {
              library = "${keaHooksPath}/libdhcp_lease_cmds.so";
            }
          ]
          ++ lib.optionals cfg.registerDynamicLeases dynamicLeasesHook;

          subnet4 = [
            {
              id = 1;
              subnet = lib.concatStringsSep "/" [
                "${config.looniversity.network.networkAddress}"
                "${toString config.looniversity.network.prefixLength}"
              ];

              pools =
                let
                  poolStart = constructIpv4Address config.looniversity.network.networkAddress "101";
                  poolEnd = constructIpv4Address config.looniversity.network.networkAddress "149";
                in
                [
                  { pool = "${poolStart} - ${poolEnd}"; }
                ];

              # TODO: Create dhcpstatic reservations
              # reservations = [
              #   {
              #     hostname = "sw1";
              #     hw-address = "10:da:43:d9:d9:d1";
              #     ip-address = "10.44.0.2";
              #   }
              # ];
            }
          ]
          ++ vlanDHCP;
        };
      };
    };
  };
}

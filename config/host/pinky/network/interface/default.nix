{
  config,
  lib,
  ...
}:
let
  wanMAC = lib.looniversity.network.netDeviceMAC config "pinky" "wan";
  lanMAC = lib.looniversity.network.netDeviceMAC config "pinky" "lan";
  # Set IP Address until we replace `pinky` machine
  lanIp = lib.looniversity.ipv4.constructIpv4Address config.looniversity.network.networkAddress "1.4";
  #lanIp = lib.looniversity.ipv4.constructIpv4Address config.looniversity.network.networkAddress "1";

  vlanDefs = config.looniversity.network.vlans;

  vlanNetDevs = lib.mapAttrs' (
    name: value:
    lib.nameValuePair "${config.looniversity.network.networkdFilePrefix.netdev}-${name}" {
      netdevConfig = {
        Kind = "vlan";
        Name = "${name}";
      };
      vlanConfig = {
        Id = value.id;
      };
    }
  ) config.looniversity.network.vlans;

  vlanNetworks = lib.mapAttrs' (
    name: value:
    lib.nameValuePair "${config.looniversity.network.networkdFilePrefix.vlanNetwork}-${name}" {
      address = [
        "${value.networkAddress}/${toString value.prefixLength}"
      ];
      linkConfig.RequiredForOnline = "enslaved";
      matchConfig = {
        Name = "${name}";
      };
      networkConfig = {
        DHCP = "no";
      };
    }
  ) config.looniversity.network.vlans;
in
{
  config = {
    systemd.network = {
      enable = true;

      wait-online.anyInterface = true;

      netdevs = vlanNetDevs;

      links = {
        "${config.looniversity.network.networkdFilePrefix.link}-wan" = {
          matchConfig.PermanentMACAddress = wanMAC;
          linkConfig.Name = "wan0";
        };

        "${config.looniversity.network.networkdFilePrefix.link}-lan" = {
          matchConfig.PermanentMACAddress = lanMAC;
          linkConfig.Name = "lan0";
        };
      };

      networks = {
        "${config.looniversity.network.networkdFilePrefix.network}-wan" = {
          linkConfig.RequiredForOnline = "routable";
          matchConfig.Name = "wan0";
          networkConfig = {
            DHCP = true;
            DNSOverTLS = true;
            DNSSEC = true;
            IPv6PrivacyExtensions = false;
          };
        };

        "${config.looniversity.network.networkdFilePrefix.network}-lan" = {
          address = [ "${lanIp}/${toString config.looniversity.network.prefixLength}" ];
          dns = config.looniversity.network.nameServers ++ config.looniversity.network.extraNameServers;
          gateway = config.looniversity.network.gateways;
          matchConfig.Name = "lan0";
          networkConfig = {
            DHCP = false;
            VLAN = lib.attrNames vlanDefs;
          };
        };
      }
      // vlanNetworks;
    };
  };
}

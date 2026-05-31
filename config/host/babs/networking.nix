{
  config,
  lib,
  ...
}:
let
  lanMAC = lib.looniversity.network.netDeviceMAC config "babs" "lan";

  inherit (lib.looniversity) disabled;
in
{
  config = {
    networking = {
      hostId = "fafececd";
      hostName = "babs";
      domain = config.looniversity.network.domainName;
      useDHCP = lib.mkDefault false;
      nftables.enable = true;
    };

    systemd.network = {
      enable = true;

      wait-online = disabled;

      links = {
        "${config.looniversity.network.networkdFilePrefix.link}-lan" = {
          matchConfig.PermanentMACAddress = lanMAC;
          linkConfig = {
            Name = "lan0";
          };
        };
      };

      networks = {
        "${config.looniversity.network.networkdFilePrefix.network}-lan" = {
          matchConfig.Name = "lan0";
          networkConfig = {
            # Using static lease in DHCP
            DHCP = "ipv4";
          };
        };
      };
    };
  };
}

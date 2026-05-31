{
  config,
  lib,
  ...
}:
let
  lanMAC = lib.looniversity.network.netDeviceMAC config "thebrain" "lan";
in
{
  config = {
    networking = {
      hostId = "cadbfefe";
      hostName = "thebrain";
      domain = config.looniversity.network.domainName;
      useDHCP = lib.mkDefault false;
    };

    systemd.network = {
      enable = true;

      wait-online.anyInterface = true;

      links = {
        "${config.looniversity.network.networkdFilePrefix.link}-lan" = {
          matchConfig.PermanentMACAddress = lanMAC;
          linkConfig.Name = "lan0";
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

{
  config,
  lib,
  ...
}:
{
  imports = [
    ./firewall
    ./interface
    ./pppoe
    ./routing
    ./vpn
  ];

  config = {
    networking = {
      hostId = "dbe3c39e";
      hostName = "pinky";

      domain = config.looniversity.network.domainName;

      nat.enable = false;

      useDHCP = lib.mkDefault false;
    };
  };
}

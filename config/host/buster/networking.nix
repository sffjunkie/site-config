{ lib, config, ... }:
let
  inherit (lib.looniversity) enabled;
in
{
  config = {
    networking = {
      hostId = "e9313abd";
      hostName = "buster";
      domain = config.looniversity.network.domainName;
      useDHCP = lib.mkDefault true;
      networkmanager = enabled;
    };
  };
}

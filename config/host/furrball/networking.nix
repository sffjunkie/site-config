{ lib, config, ... }:
let
  inherit (lib.looniversity) enabled;
in
{
  config = {
    networking = {
      hostId = "8ddbb68e";
      hostName = "furrball";
      domain = config.looniversity.network.domainName;
      useDHCP = lib.mkDefault true;
      networkmanager = enabled;
    };
  };
}

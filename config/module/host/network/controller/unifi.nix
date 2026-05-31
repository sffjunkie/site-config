{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.network.unifi;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.network.unifi = {
    enable = mkEnableOption "unifi";
  };

  config = mkIf cfg.enable {
    services.unifi = {
      enable = true;
      openFirewall = true;
    };
  };
}

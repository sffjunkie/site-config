{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.network.service.dns-m;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.network.service.dns-m = {
    enable = mkEnableOption "mdns";
  };

  config = mkIf cfg.enable {
    services.avahi = {
      enable = true;
    };
  };
}

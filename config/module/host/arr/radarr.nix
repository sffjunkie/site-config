{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.arr.radarr;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.arr.radarr = {
    enable = mkEnableOption "radarr";
  };

  config = mkIf cfg.enable {
    users.groups.media.members = [ "radarr" ];

    services.radarr = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
  };
}

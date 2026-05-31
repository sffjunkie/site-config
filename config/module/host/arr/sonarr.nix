{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.arr.sonarr;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.arr.sonarr = {
    enable = mkEnableOption "sonarr";
  };

  config = mkIf cfg.enable {
    users.groups.media.members = [ "sonarr" ];

    services.sonarr = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
  };
}

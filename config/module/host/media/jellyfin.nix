{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.media.jellyfin;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.media.jellyfin = {
    enable = mkEnableOption "jellyfin";
  };

  config = mkIf cfg.enable {
    services = {
      jellyfin = {
        enable = true;
        openFirewall = true;
        group = "media";
      };
    };
  };
}

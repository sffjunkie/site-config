{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.system.user-dirs;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.system.user-dirs = {
    enable = mkEnableOption "user-dirs";
  };

  config = mkIf cfg.enable {
    xdg.userDirs = {
      enable = true;
      setSessionVariables = false;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      publicShare = "${config.home.homeDirectory}/public";
      templates = "${config.home.homeDirectory}/templates";
      videos = "${config.home.homeDirectory}/videos";
    };
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.desktop.environment.gnome;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.desktop.environment.gnome = {
    enable = mkEnableOption "gnome";
  };

  config = mkIf cfg.enable {
    services = {
      displayManager.defaultSession = "gnome";
      displayManager.gdm = enabled;
      desktopManager.gnome = enabled;
    };
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.wayland;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.wayland = {
    enable = mkEnableOption "wayland environment";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      _JAVA_AWT_WM_NONREPARENTING = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland,x11,windows";
    };
  };
}

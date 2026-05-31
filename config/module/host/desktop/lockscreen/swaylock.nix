{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.desktop.lockscreen.swaylock;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.desktop.lockscreen.swaylock = {
    enable = mkEnableOption "swaylock";
  };

  config = mkIf cfg.enable {
    security.pam.services.swaylock.text = ''
      auth include login
    '';
  };
}

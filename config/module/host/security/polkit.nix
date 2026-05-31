{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.looniversity.security.polkit;
in
{
  options.looniversity.security.polkit = {
    enable = mkEnableOption "polkit";
  };

  config = mkIf cfg.enable {
    security.polkit = {
      enable = true;

      extraConfig = ''
        polkit.addRule(function(action, subject) {
            if (
                action.id == "org.freedesktop.systemd1.manage-units" &&
                subject.isInGroup("wheel")
            ) {
                return polkit.Result.AUTH_KEEP;
            }
        });
      '';
    };
  };
}

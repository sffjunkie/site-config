{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.looniversity.security.polkit-gnome;
in
{
  options.looniversity.security.polkit-gnome = {
    enable = mkEnableOption "polkit-gnome";

    systemdTarget = mkOption {
      type = types.str;
      default = "graphical-session.target";
      example = "wayland-session.target";
      description = ''
        Systemd target to bind to.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.polkit_gnome
    ];

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Unit.ConditionEnvironment = "WAYLAND_DISPLAY";
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
      Install = {
        WantedBy = [ cfg.systemdTarget ];
      };
    };
  };
}

{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.desktop.lockscreen.swaylock;
  swaylock = "${pkgs.swaylock}/bin/swaylock -fF";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.desktop.lockscreen.swaylock = {
    enable = mkEnableOption "swaylock/swayidle lockscreen";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.looniversity.desktop.lockscreen.swaylock.enable;
        message = "Swaylock host module must be enabled";
      }
    ];

    programs.swaylock = {
      enable = true;
    };

    services.swayidle = {
      enable = true;
      systemdTargets = [ "lde-session.target" ];
      extraArgs = [
        "-d"
      ];
      timeouts = [
        {
          timeout = 300;
          command = swaylock;
        }
        {
          timeout = 600;
          command = "${pkgs.coreutils}/bin/sleep 1; ${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = {
        "before-sleep" = swaylock;
        "lock" = swaylock;
      };
    };

    systemd.user.services.swayidle = {
      Unit.ConditionEnvironment = "WAYLAND_DISPLAY";
    };
  };
}

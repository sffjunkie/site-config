{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.desktop.lockscreen.swaylock;
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock -fF";
  indicator-radius = 200;
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

      settings = {
        clock = true;
        effect-greyscale = true;
        image = config.looniversity.user.theme.lockscreen.image;
        indicator = true;
        indicator-radius = indicator-radius;
        indicator-x-position = indicator-radius + 400;
      };
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

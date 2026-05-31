{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.looniversity.system.elephant;
in
{
  options.looniversity.system.elephant = {
    enable = lib.mkEnableOption "Elephant application launcher backend";

    package = lib.mkPackageOption pkgs "elephant" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.elephant = {
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "Elephant application launcher backend";
        PartOf = [ "lde-session.target" ];
        After = [ "lde-session.target" ];
      };
      Install.WantedBy = [ "lde-session.target" ];
      Service = {
        Restart = "always";
        RestartSec = 10;
        ExecStart = "${cfg.package}/bin/elephant";
      };
    };

    home.packages = [ cfg.package ];
  };
}

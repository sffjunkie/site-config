{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.desktop.lockscreen.idle-inhibit;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.desktop.lockscreen.idle-inhibit = {
    enable = mkEnableOption "Inhibit lock screen if audio playing";
  };

  config = mkIf cfg.enable {
    services.wayland-pipewire-idle-inhibit = {
      enable = true;
      systemdTarget = "lde-session.target";

      settings = {
        verbosity = "INFO";
        media_minimum_duration = 10;
        idle_inhibitor = "wayland";

        sink_whitelist = [
          { name = "Pebble V3 Analog Stereo"; }
          { name = "Navi 21/23 HDMI/DP Audio Controller Digital Stereo (HDMI)"; }
        ];

        node_blacklist = [
          { name = "spotify"; }
          { app_name = "Music Player Daemon"; }
        ];
      };
    };
  };
}

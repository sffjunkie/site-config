{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.desktop.mako;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.looniversity.desktop.mako = {
    enable = mkEnableOption "mako notifications";
  };

  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      settings = {
        anchor = "top-right";
        outer-margin = "45,8";
        font = lib.mkForce "JetBrainsMono Nerd Font 13";
        border-radius = 5;

        "app-name=lde-cal" = {
          text-alignment = "center";
          height = 500;
        };

        "app-name=music-notify" = {
          width = builtins.floor (256 * 2.25);
          height = 256;
          max-icon-size = 256;
          anchor = "bottom-right";
          outer-margin = "64,8";
          format = "%b";
          icon-border-radius = 5;
        };
      };
    };
  };
}

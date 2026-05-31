{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.cli.zellij;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.zellij = {
    enable = mkEnableOption "zellij";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        show_startup_tips = false;
        keybinds = {
          unbind = [ "Ctrl q" ];
        };
        ui = {
          pane_frames = {
            hide_session_name = true;
          };
        };
      };
    };
  };
}

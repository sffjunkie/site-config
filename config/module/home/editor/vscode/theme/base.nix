{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.editor.vscode;
  inherit (lib) mkDefault mkIf;
in
{
  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          userSettings = {
            "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'DejaVu Sans Mono', monospace";

            "editor.fontSize" = 12;

            "editor.rulers" = [
              80
              100
            ];

            "window.titleBarStyle" = "custom";
            "window.zoomLevel" = mkDefault 2;

            "workbench.panel.defaultLocation" = "right";
            "workbench.startupEditor" = "readme";
          };
        };
      };
    };
  };
}

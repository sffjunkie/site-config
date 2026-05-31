{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.theme.catppuccin;
  inherit (lib) mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
    catppuccin.catppuccin-vsc
    catppuccin.catppuccin-vsc-icons
  ];
in
{
  options.looniversity.editor.vscode.theme.catppuccin = {
    enable = mkEnableOption "vscode catppuccin theme";
  };

  config = mkIf cfg.enable {
    looniversity.theme.stylix.disabledTargets = [ "vscode" ];

    programs.vscode = {
      profiles = {
        default = {
          extensions = vscodeExtensions;

          userSettings = mkIf (!config.stylix.targets.vscode.enable) {
            "workbench.colorTheme" = "Catppuccin Macchiato";
            "workbench.iconTheme" = "catppuccin-macchiato";
          };
        };
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.markdown;
  inherit (lib) mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
    bierner.markdown-mermaid
    davidanson.vscode-markdownlint
    shd101wyy.markdown-preview-enhanced
    yzhang.markdown-all-in-one
  ];
in
{
  options.looniversity.editor.vscode.markdown = {
    enable = mkEnableOption "vscode markdown configuration";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          extensions = vscodeExtensions;

          userSettings = {
            "markdownlint.config" = {
              "MD033" = false;
            };
            "markdown.preview.fontSize" = mkIf (!config.stylix.targets.vscode.enable) 12;
            "markdown.preview.fontFamily" = mkIf (
              !config.stylix.targets.vscode.enable
            ) "'JetBrainsMono Nerd Font', 'DejaVu Sans Mono', monospace";

            "[markdown]" = {
              "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
            };

            "markdownlint.lintWorkspaceGlobs" = [
              "**/*.{md,mkd,mdwn,mdown,markdown,markdn,mdtxt,mdtext,workbook}"
              "!**/*.code-search"
              "!**/bower_components"
              "!**/node_modules"
              "!**/.git"
              "!**/vendor"
              "!LICENSE"
            ];
          };
        };
      };
    };
  };
}

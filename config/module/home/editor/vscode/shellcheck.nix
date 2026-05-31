{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.shellcheck;
  inherit (lib) mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
    timonwong.shellcheck
  ];
in
{
  options.looniversity.editor.vscode.shellcheck = {
    enable = mkEnableOption "vscode shellcheck configuration";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          extensions = vscodeExtensions;

          userSettings = {
            "shellcheck.ignorePatterns" = {
              "**/.envrc" = true;
            };
          };
        };
      };
    };
  };
}

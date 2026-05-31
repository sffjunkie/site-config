{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.toml;
  inherit (lib) mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
    tamasfe.even-better-toml
  ];
in
{
  options.looniversity.editor.vscode.toml = {
    enable = mkEnableOption "vscode toml configuration";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          extensions = vscodeExtensions;

          userSettings = {
            "evenBetterToml.formatter.arrayTrailingComma" = true;
            "evenBetterToml.formatter.arrayAutoExpand" = true;
          };
        };
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.nix;
  inherit (lib) mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    brettm12345.nixfmt-vscode
  ];
in
{
  options.looniversity.editor.vscode.nix = {
    enable = mkEnableOption "vscode nix configuration";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          extensions = vscodeExtensions;

          userSettings = {
            "files.exclude" = {
              result = true;
            };
            "[nix]" = {
              "editor.tabSize" = 2;
              "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
            };
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
            "nix.serverSettings" = {
              "nixd" = {
                "formatting" = {
                  "command" = [ "${pkgs.nixfmt}/bin/nixfmt" ];
                };
              };
            };
            "nix.hiddenLanguageServerErrors" = [
              "textDocument/definition"
            ];
            "nixfmt.path" = "${pkgs.nixfmt}/bin/nixfmt";
          };
        };
      };
    };

    home.packages = [
      pkgs.nixd
      pkgs.nixfmt
    ];
  };
}

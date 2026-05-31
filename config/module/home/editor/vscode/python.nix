{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.python;
  inherit (lib) mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
    ms-python.python
    ms-python.vscode-pylance
  ];

  marketplaceExtensionsList =
    with inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace; [
      charliermarsh.ruff
    ];
in
{
  options.looniversity.editor.vscode.python = {
    enable = mkEnableOption "vscode python configuration";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          extensions = vscodeExtensions ++ marketplaceExtensionsList;

          userSettings = {
            "files.exclude" = {
              "**/__pycache__" = true;
              "**/.direnv" = true;
              "**/.mypy_cache" = true;
              "**/.pytest_cache" = true;
              "**/.ruff_cache" = true;
              "**/.tox" = true;
              "**/.venv" = true;
            };
            "python.analysis.diagnosticMode" = "workspace";
            "python.analysis.exclude" = [
              ".*"
              "**/node_modules"
              "**/__pycache__"
              "**/.devenv"
              "**/.direnv"
              "**/.tox"
              "**/.venv"
              "**/result"
            ];
            "python.analysis.typeCheckingMode" = "standard";
            "[python]" = {
              "editor.defaultFormatter" = "ms-python.black-formatter";
            };
          };
        };
      };
    };
  };
}

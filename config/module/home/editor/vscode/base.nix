{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode;
  inherit (lib) mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
    arcticicestudio.nord-visual-studio-code
    bierner.markdown-mermaid
    editorconfig.editorconfig
    dotjoshjohnson.xml
    fill-labs.dependi
    github.vscode-github-actions
    golang.go
    gruntfuggly.todo-tree
    humao.rest-client
    mkhl.direnv
    ms-vscode.makefile-tools
    ms-vscode-remote.remote-containers
    oderwat.indent-rainbow
    pkief.material-icon-theme
    stkb.rewrap
    twxs.cmake
    esbenp.prettier-vscode
    dbaeumer.vscode-eslint
    github.vscode-pull-request-github
    foxundermoon.shell-format
  ];

  marketplaceExtensionsList =
    with inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace; [
      dlasagno.rasi
      dongfg.vscode-beancount-formatter
      drblury.protobuf-vsc
      executablebookproject.myst-highlight
      github.remotehub
      kennylong.kubernetes-yaml-formatter
      lencerf.beancount
      ms-vscode.cpptools-extension-pack
      ramyaraoa.show-offset
      rust-lang.rust-analyzer
      shipitsmarter.sops-edit
      techer.open-in-browser
      tomphilbin.gruvbox-themes
      runem.lit-plugin
      elagil.pre-commit-helper
    ];
in
{
  options.looniversity.editor.vscode = {
    enable = mkEnableOption "vscode";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;

      mutableExtensionsDir = true;
      profiles = {
        default = {
          extensions = vscodeExtensions ++ marketplaceExtensionsList;

          userSettings = {
            "cSpell.enabled" = false;

            "diffEditor.ignoreTrimWhitespace" = false;
            "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";

            "editor.foldingHighlight" = false;
            "editor.formatOnSave" = true;
            "editor.lineNumbers" = "relative";
            "editor.parameterHints.enabled" = false;
            "editor.semanticHighlighting.enabled" = true;

            "explorer.confirmDragAndDrop" = false;
            "explorer.compactFolders" = false;
            "explorer.confirmDelete" = false;

            "files.insertFinalNewline" = true;
            "files.exclude" = {
              "**/.devenv" = true;
              "**/.direnv" = true;
            };

            "git.path" = "${pkgs.gitFull}/bin/git";
            "git.detectWorktrees" = false;

            "terminal.integrated.scrollback" = 5000;
            "terminal.integrated.fontSize" = mkIf (!config.stylix.targets.vscode.enable) 12;
            "terminal.integrated.defaultProfile.linux" = "bash";

            "testing.automaticallyOpenTestResults" = "neverOpen";

            "update.mode" = "manual";

            "workbench.startupEditor" = "readme";

            "[jsonc]" = {
              "editor.defaultFormatter" = "vscode.json-language-features";
            };
          };
        };
      };
    };
  };
}

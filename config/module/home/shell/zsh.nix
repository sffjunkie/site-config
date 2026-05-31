{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.shell.zsh;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.shell.zsh = {
    enable = mkEnableOption "zsh";

    initContent = mkOption {
      default = "";
      type = types.lines;
      description = "Extra commands that should be added to {file}`.zshrc`.";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      inherit (config.looniversity.shell.zsh) initContent;
      enable = true;
      autosuggestion = enabled;
      dotDir = "${config.xdg.configHome}/zsh";
      enableCompletion = true;
      completionInit = ''
        autoload -Uz compinit
        fpath=(''${(ou)fpath}) # Stable fpath order hence consistent cache hit.
        if [[ ! -s ''${ZDOTDIR:-$HOME}/.zcompdump || \
              /run/current-system/sw -nt ''${ZDOTDIR:-$HOME}/.zcompdump ]]; then
          compinit
          zcompile ''${ZDOTDIR:-$HOME}/.zcompdump 2>/dev/null
        else
          compinit -C
        fi
      '';
      syntaxHighlighting = enabled;
    };

    programs.zsh.antidote = {
      enable = true;
      plugins = [
        "ptavares/zsh-direnv"
        "ohmyzsh/ohmyzsh path:lib"
        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/sudo"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-syntax-highlighting"
      ];
    };
  };
}

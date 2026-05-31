{ config, lib, ... }:
let
  repo = "github:sffjunkie/devshell/main";

  inherit (lib) mkIf mkEnableOption;
in
{
  options.looniversity.shellcmd.nds.enable = mkEnableOption "nix development shell command";

  config = mkIf config.looniversity.shellcmd.nds.enable {
    nix.registry = {
      devshell = {
        from = {
          id = "devshell";
          type = "indirect";
        };
        to = {
          path = "/home/sdk/development/project/devshell";
          type = "path";
        };
      };
    };

    programs.zsh.initContent = mkIf config.home.shell.enableZshIntegration ''
      nds() { nix develop '${repo}#''${1}' }
    '';
  };
}

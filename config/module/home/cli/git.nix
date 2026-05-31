{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.git;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      signing.format = null;

      settings = {
        user.name = "Simon Kennedy";
        user.email = "sffjunkie+code@gmail.com";
        user.signingkey = "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOHRx/DnAv9IFTbUoWtjyNDF92lXa5dLQohrdp/5SVGd";

        commit.gpgsign = true;
        gpg.format = "ssh";

        init.defaultBranch = "main";
        credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
        http.postBuffer = "157286400";
      };
    };

    programs.zsh.shellAliases = {
      gvl = "git config --list --show-origin";
    };
  };
}

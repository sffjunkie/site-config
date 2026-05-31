{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.security.gpg;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.looniversity.security.gpg.enable = mkEnableOption "gpg";

  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      homedir = "${config.home.homeDirectory}/.local/share/gnupg";
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 1800;
      pinentry.package = pkgs.pinentry-gtk2;
    };
  };
}

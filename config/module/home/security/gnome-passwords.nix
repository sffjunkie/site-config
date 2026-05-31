{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.security.gnome-passwords;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.security.gnome-passwords = {
    enable = mkEnableOption "Gnome Passwords and Keys";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.seahorse
    ];
  };
}

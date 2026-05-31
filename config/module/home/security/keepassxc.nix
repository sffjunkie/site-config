{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.security.keepassxc;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.security.keepassxc = {
    enable = mkEnableOption "keepassxc";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.keepassxc
    ];
  };
}

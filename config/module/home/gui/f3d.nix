{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.f3d;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.f3d = {
    enable = mkEnableOption "f3d";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.f3d
      pkgs.zenity
    ];
  };
}

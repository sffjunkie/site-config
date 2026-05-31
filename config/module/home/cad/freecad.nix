{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cad.freecad;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cad.freecad = {
    enable = mkEnableOption "FreeCAD";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.freecad
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cad.sweethome3d;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cad.sweethome3d = {
    enable = mkEnableOption "SweetHome 3D";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.sweethome3d.application
    ];
  };
}

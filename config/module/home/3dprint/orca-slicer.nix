{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.print3d.orca-slicer;

  scriptContents = builtins.readFile ./addMD5.py;

  md5Script = pkgs.writers.writePython3Bin "addMD5.py" { } scriptContents;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.print3d.orca-slicer = {
    enable = mkEnableOption "Orca Slicer";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.orca-slicer
      pkgs.nanum
    ];

    home.file.".local/bin/addMD5.py" = {
      source = lib.getExe' md5Script "addMD5.py";
    };
  };
}

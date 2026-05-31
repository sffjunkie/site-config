{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.obsidian;

  desktopItem = pkgs.makeDesktopItem {
    name = "obsidian";
    desktopName = "Obsidian";
    genericName = "Obsidian";
    comment = "2nd Brain";
    icon = "nix-snowflake";
    exec = "${lib.getExe pkgs.obsidian} --ozone-platform=wayland";
    mimeTypes = [ "text/markdown" ];
  };

  wrapped = pkgs.symlinkJoin {
    name = pkgs.obsidian.pname;
    paths = [
      desktopItem
      pkgs.obsidian
    ];
  };

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.obsidian = {
    enable = mkEnableOption "obsidian";
  };

  config = mkIf cfg.enable {
    home.packages = [
      wrapped
    ];
  };
}

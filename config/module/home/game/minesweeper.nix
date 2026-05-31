{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.game.minesweeper;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.game.minesweeper = {
    enable = mkEnableOption "gnome-mines (minesweeper)";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-mines
    ];
  };
}

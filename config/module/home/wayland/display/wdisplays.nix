{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.wayland.display.wdisplays;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.wayland.display.wdisplays = {
    enable = mkEnableOption "wdisplays display management";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.wdisplays
    ];

    looniversity.wayland.display.wlr-randr = enabled;
  };
}

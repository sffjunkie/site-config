{ config, lib, ... }:
let
  cfg = config.looniversity.theme.rofi;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.theme.rofi = {
    enable = mkEnableOption "theme for rofi";
  };

  config = mkIf cfg.enable {
    programs.rofi.enable = true;
    xdg.configFile."rofi/looniversity.rasi".source = ./looniversity.rasi;
  };
}

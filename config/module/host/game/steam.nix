{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.game.steam;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.game.steam = {
    enable = mkEnableOption "steam";
  };

  config = mkIf cfg.enable {
    hardware.graphics.enable32Bit = true;

    programs.gamemode = enabled;
    programs.steam = {
      enable = true;

      extest = enabled;
      gamescopeSession = enabled;

      extraPackages = [ pkgs.hidapi ];

      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}

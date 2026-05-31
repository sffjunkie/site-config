{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.game.solitaire;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.game.solitaire = {
    enable = mkEnableOption "solitaire (AisleRiot)";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.aisleriot
    ];
  };
}

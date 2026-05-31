{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.media.playerctl;

  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.looniversity.media.playerctl = {
    enable = mkEnableOption "playerctl";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.playerctl ];
  };
}

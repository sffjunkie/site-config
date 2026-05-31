{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.pulsemixer;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.pulsemixer = {
    enable = mkEnableOption "pulsemixer";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.pulsemixer
    ];
  };
}

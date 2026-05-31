{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.onefetch;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.onefetch = {
    enable = mkEnableOption "onefetch";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.onefetch
    ];
  };
}

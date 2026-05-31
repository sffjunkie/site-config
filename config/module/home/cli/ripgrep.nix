{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.ripgrep;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.ripgrep = {
    enable = mkEnableOption "ripgrep";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ripgrep
    ];
  };
}

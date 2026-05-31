{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.system.pywal;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.system.pywal = {
    enable = mkEnableOption "pywal";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.pywal
    ];
  };
}

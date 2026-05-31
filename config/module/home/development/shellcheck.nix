{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.shellcheck;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.development.shellcheck = {
    enable = mkEnableOption "shellcheck";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.shellcheck
    ];
  };
}

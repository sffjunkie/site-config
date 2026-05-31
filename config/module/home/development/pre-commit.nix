{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.pre-commit;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.development.pre-commit = {
    enable = mkEnableOption "pre-commit";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.pre-commit
    ];
  };
}

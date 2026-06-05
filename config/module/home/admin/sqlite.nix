{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.admin.sqlite;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.admin.sqlite = {
    enable = mkEnableOption "sqlite admin";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.sqlitebrowser
    ];
  };
}

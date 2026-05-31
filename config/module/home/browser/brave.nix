{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.brave;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.brave = {
    enable = mkEnableOption "brave";
  };

  config = mkIf (cfg.enable || config.looniversity.user.apps.browser == "brave") {
    home.packages = [
      pkgs.brave
    ];

    programs.ranger.rifle = lib.mkBefore [
      {
        condition = "ext x?html?, has brave, X, flag f";
        command = ''brave -- "$@"'';
      }
    ];
  };
}

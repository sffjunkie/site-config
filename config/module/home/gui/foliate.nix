{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.foliate;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.foliate = {
    enable = mkEnableOption "foliate";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.foliate
    ];

    xdg.mimeApps = {
      defaultApplications = {
        "application/epub+zip" = lib.mkDefault [ "foliate.desktop" ];
      };
    };
  };
}

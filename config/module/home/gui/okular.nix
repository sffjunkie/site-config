{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.okular;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.okular = {
    enable = mkEnableOption "okular";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.kdePackages.okular
    ];

    xdg.mimeApps = {
      defaultApplications = {
        "application/pdf" = lib.mkDefault [ "okular.desktop" ];
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.qt6;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.development.pre-commit = {
    enable = mkEnableOption "pre-commit";
  };

  config = mkIf cfg.enable {
    home.sessionPath = [ "${pkgs.qt6.qtbase}/libexec/" ];

    home.sessionVariables = {
      QML_IMPORT_PATH = "${pkgs.qt6.qtdeclarative}/${pkgs.qt6.qtbase.qtQmlPrefix}";
      QT_PLUGIN_PATH = "${pkgs.qt6.qtbase}/lib/qt-6/plugins";
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.qt6;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.development.qt6 = {
    enable = mkEnableOption "pre-commit";

    qt6Full = mkOption {
      type = types.listOf types.package;
      default = [
        pkgs.qt6.qtbase
        pkgs.qt6.qt3d
        pkgs.qt6.qt5compat
        pkgs.qt6.qtcharts
        pkgs.qt6.qtconnectivity
        pkgs.qt6.qtdatavis3d
        pkgs.qt6.qtdeclarative
        pkgs.qt6.qtdoc
        pkgs.qt6.qtgraphs
        pkgs.qt6.qtgrpc
        pkgs.qt6.qthttpserver
        pkgs.qt6.qtimageformats
        pkgs.qt6.qtlanguageserver
        pkgs.qt6.qtlocation
        pkgs.qt6.qtlottie
        pkgs.qt6.qtmultimedia
        pkgs.qt6.qtmqtt
        pkgs.qt6.qtnetworkauth
        pkgs.qt6.qtpositioning
        pkgs.qt6.qtsensors
        pkgs.qt6.qtserialbus
        pkgs.qt6.qtserialport
        pkgs.qt6.qtshadertools
        pkgs.qt6.qtspeech
        pkgs.qt6.qtquick3d
        pkgs.qt6.qtquick3dphysics
        pkgs.qt6.qtquickeffectmaker
        pkgs.qt6.qtquicktimeline
        pkgs.qt6.qtremoteobjects
        pkgs.qt6.qtsvg
        pkgs.qt6.qtscxml
        pkgs.qt6.qttools
        pkgs.qt6.qttranslations
        pkgs.qt6.qtvirtualkeyboard
        pkgs.qt6.qtwayland
        pkgs.qt6.qtwebchannel
        pkgs.qt6.qtwebengine
        pkgs.qt6.qtwebsockets
        pkgs.qt6.qtwebview
        pkgs.qt6.wrapQtAppsHook
        pkgs.qt6.qtwayland
        pkgs.libglvnd
      ];
    };
  };

  config = mkIf cfg.enable {
    home.sessionPath = [ "${pkgs.qt6.qtbase}/libexec/" ];

    home.sessionVariables = {
      QML_IMPORT_PATH = "${pkgs.qt6.qtdeclarative}/${pkgs.qt6.qtbase.qtQmlPrefix}";
      QT_PLUGIN_PATH = "${pkgs.qt6.qtbase}/lib/qt-6/plugins";
    };
  };
}

{
  lib,
  pkgs,
  ...
}:
pkgs.writeShellScriptBin "rofi-app-launcher" ''
  ${lib.getExe pkgs.rofi} \
    -theme-str '@import "looniversity"' \
    -modi drun \
    -show drun
''

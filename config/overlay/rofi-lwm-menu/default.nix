{
  lib,
  pkgs,
  ...
}:
let
  qtilePkg = "${pkgs.python3.pkgs.qtile}";
  scriptCode = lib.replaceString "##pkgs.qtile##" qtilePkg (builtins.readFile ./rofi-lwm-menu.sh);
  shellScript = pkgs.writeShellScriptBin "rofi-lwm-menu.sh" scriptCode;
in
pkgs.writeShellScriptBin "rofi-lwm-menu" ''
  ${lib.getExe pkgs.rofi} \
    -theme-str '@import "looniversity"' \
    -show lwm-menu \
    -modi "lwm-menu:${lib.getExe shellScript}"
''

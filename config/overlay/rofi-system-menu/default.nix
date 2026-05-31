{
  lib,
  pkgs,
  ...
}:
pkgs.writeShellScriptBin "rofi-system-menu" ''
  swapon --show | grep "dev" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    hibernate_choice="/hibernate"
  else
    hibernate_choice=""
  fi

  choices="suspend/lockscreen/logout''${hibernate_choice}/reboot/shutdown"
  ${lib.getExe pkgs.rofi} \
    -theme-str '@import "looniversity"' \
    -show power-menu \
    -modi "power-menu:${lib.getExe pkgs.rofi-power-menu} --choices=''${choices}"
''

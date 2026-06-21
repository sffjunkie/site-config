{
  formatter,
  lib,
  pkgs,
  ...
}:
formatter.generate "desktop-menu" {
  menu = {
    wm = lib.getExe pkgs.rofi-lwm-menu;
    system = lib.getExe pkgs.rofi-system-menu;
  };
}

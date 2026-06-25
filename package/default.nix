{ pkgs, ... }:
let
  sysinfoPackage = pkgs.callPackage ./sysinfo.nix { };
in
{
  default = sysinfoPackage;
  music-notify = pkgs.callPackage ./music-notify.nix { };
  musicctl = pkgs.callPackage ./musicctl.nix { };
  rofi-app-launcher = pkgs.callPackage ./rofi-app-launcher.nix { };
  rofi-clip = pkgs.callPackage ./rofi-clip.nix { };
  rofi-lwm-menu = pkgs.callPackage ./rofi-lwm-menu { };
  rofi-system-menu = pkgs.callPackage ./rofi-system-menu.nix { };
  sshot = pkgs.callPackage ./sshot.nix { };
  sysinfo = sysinfoPackage;
  volumectl = pkgs.callPackage ./volumectl.nix { };
}

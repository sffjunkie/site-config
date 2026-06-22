{ pkgs, ... }:
{
  rofi-app-launcher = pkgs.callPackage ./rofi-app-launcher.nix { };
  rofi-lwm-menu = pkgs.callPackage ./rofi-lwm-menu { };
  rofi-system-menu = pkgs.callPackage ./rofi-system-menu.nix { };
  rofi-clip = pkgs.callPackage ./rofi-clip.nix { };
  sshot = pkgs.callPackage ./sshot.nix { };
  musicctl = pkgs.callPackage ./musicctl.nix { };
  music-notify = pkgs.callPackage ./music-notify.nix { };
  volumectl = pkgs.callPackage ./volumectl.nix { };
}

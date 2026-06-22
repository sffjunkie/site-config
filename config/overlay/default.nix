{ config, self, ... }:
{
  config = {
    nixpkgs.overlays = [
      (_: prev: {
        openldap = prev.openldap.overrideAttrs {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        };
      })
      (post: pre: {
        rofi-app-launcher = pre.callPackage ./rofi-app-launcher { };
        rofi-lwm-menu = pre.callPackage ./rofi-lwm-menu { };
        rofi-system-menu = pre.callPackage ./rofi-system-menu { };
        rofi-clip = pre.callPackage ./rofi-clip { };
        sshot = pre.callPackage ./sshot { };
        musicctl = pre.callPackage ./musicctl { };
        volumectl = pre.callPackage ./volumectl { };
        music-notify = pre.callPackage ./music-notify {
          musicMount = config.looniversity.mount.music.mount_point;
        };
      })
    ];
  };
}

{ self, ... }:
{
  config = {
    nixpkgs.overlays = [
      (_: prev: {
        openldap = prev.openldap.overrideAttrs {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        };
      })
      (
        _: prev:
        let
          system = prev.stdenv.hostPlatform.system;
          packages = self.packages.${system}.default;
        in
        {
          rofi-app-launcher = packages.rofi-app-launcher;
          rofi-lwm-menu = packages.rofi-lwm-menu;
          rofi-system-menu = packages.rofi-system-menu;
          rofi-clip = packages.rofi-clip;
          sshot = packages.sshot;
          musicctl = packages.musicctl;
          music-notify = packages.music-notify;
          volumectl = packages.volumectl;
        }
      )
    ];
  };
}

{ self, ... }:
{
  config = {
    nixpkgs.overlays = [
      (
        _: prev:
        let
          system = prev.stdenv.hostPlatform.system;
          packages = self.packages.${system};
        in
        {
          music-notify = packages.music-notify;
          musicctl = packages.musicctl;
          rofi-app-launcher = packages.rofi-app-launcher;
          rofi-clip = packages.rofi-clip;
          rofi-lwm-menu = packages.rofi-lwm-menu;
          rofi-system-menu = packages.rofi-system-menu;
          sshot = packages.sshot;
          sysinfo = packages.sysinfo;
          volumectl = packages.volumectl;
        }
      )
    ];
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.mount.movies;

  lanIpv4 = lib.looniversity.network.lanIpv4 config "babs";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.movies = {
    enable = mkEnableOption "Movies";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/movies" = {
      device = "${lanIpv4}:/tank1/movies";
      fsType = "nfs";
      options = [
        "_netdev"
        "noauto"
        "x-systemd.automount"
        "x-systemd.device-timeout=10s"
      ];
    };
  };
}

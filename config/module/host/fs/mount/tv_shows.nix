{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.mount.tv_shows;

  lanIpv4 = lib.looniversity.network.lanIpv4 config "babs";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.tv_shows = {
    enable = mkEnableOption "TV Shows";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/tv_shows" = {
      device = "${lanIpv4}:/tank1/tv_shows";
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

{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.mount.roms;

  lanIpv4 = lib.looniversity.network.lanIpv4 config "babs";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.roms = {
    enable = mkEnableOption "roms";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/roms" = {
      device = "${lanIpv4}:/tank1/roms";
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

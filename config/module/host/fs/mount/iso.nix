{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.mount.iso;

  lanIpv4 = lib.looniversity.network.lanIpv4 config "babs";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.iso = {
    enable = mkEnableOption "ISO";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/iso" = {
      device = "${lanIpv4}:/tank0/iso";
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

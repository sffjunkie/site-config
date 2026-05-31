{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.mount.pictures;

  lanIpv4 = lib.looniversity.network.lanIpv4 config "babs";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.pictures = {
    enable = mkEnableOption "pictures";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/pictures" = {
      device = "${lanIpv4}:/tank0/pictures";
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

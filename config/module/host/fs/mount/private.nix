{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.mount.private;

  lanIpv4 = lib.looniversity.network.lanIpv4 config "babs";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.private = {
    enable = mkEnableOption "Private";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/private" = {
      device = "${lanIpv4}:/tank1/private";
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

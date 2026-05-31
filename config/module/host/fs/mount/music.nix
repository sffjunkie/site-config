{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.mount.music;

  lanIpv4 = lib.looniversity.network.lanIpv4 config "babs";

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.mount.music = {
    enable = mkEnableOption "music";
    automount = mkEnableOption "automount";
    mount_point = mkOption {
      type = types.str;
      default = "/mnt/music";
    };
  };

  config = mkIf cfg.enable {
    fileSystems."${cfg.mount_point}" = {
      device = "${lanIpv4}:/tank1/music";
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

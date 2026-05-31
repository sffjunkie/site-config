{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.storage.zfs.autoscrub;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.storage.zfs.autoscrub = {
    enable = mkEnableOption "ZFS auto scrubbing";
  };

  config = mkIf cfg.enable {
    services.zfs.autoScrub = enabled;
  };
}

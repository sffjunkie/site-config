{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.arr_stack;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.role.arr_stack = {
    enable = mkEnableOption "arr stack role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      arr = {
        bazarr = enabled;
        prowlarr = enabled;
        radarr = enabled;
        sabnzbd = enabled;
        sonarr = enabled;
      };
    };
  };
}

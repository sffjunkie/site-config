{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.podcaster;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.role.podcaster = {
    enable = mkEnableOption "podcaster role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      media = {
        obs-studio = enabled;
      };
    };
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.service.syncthing;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.service.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing = enabled;
  };
}

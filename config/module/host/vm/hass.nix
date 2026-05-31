{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.vm.hass;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.vm.hass = {
    enable = mkEnableOption "Home Assistant vm";
  };

  config = mkIf cfg.enable {
    looniversity = {
      virtualisation.server = enabled;
    };
  };
}

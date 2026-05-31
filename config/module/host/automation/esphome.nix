{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.automation.esphome;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.automation.esphome = {
    enable = mkEnableOption "esphome";
  };

  config = mkIf cfg.enable {
    services.esphome = {
      enable = true;
    };
  };
}

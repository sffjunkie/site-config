{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.automation.openthread-border-router;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.automation.openthread-border-router = {
    enable = mkEnableOption "openthread-border-router";

    otbr_pan_id = mkOption {
      type = types.str;
      default = "wpan0";
    };

    otbr_device_id = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    services.openthread-border-router = {
      enable = true;
      openFirewall = true;

      backboneInterfaces = [ "lan0" ];

      radio = {
        baudRate = 460800;
        device = config.looniversity.automation.openthread-border-router.otbr_device_id;
      };

      rest = {
        listenAddress = "0.0.0.0";
      };

      web = {
        enable = true;
        listenAddress = "0.0.0.0";
      };
    };
  };
}

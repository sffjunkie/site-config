{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.admin.mqtt;

  mqttHost = lib.looniversity.network.serviceHandlerHost config "mosquitto";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.admin.mqtt = {
    enable = mkEnableOption "mqtt";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.mqttui
    ];

    environment.shellAliases = {
      mqttui = "mqttui --broker \"mqtt://${mqttHost}\"";
    };
  };
}

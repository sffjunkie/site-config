{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.automation.mosquitto;
  port = 1883;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.automation.mosquitto = {
    enable = mkEnableOption "mosquitto";
  };

  config = mkIf cfg.enable {
    services.mosquitto = {
      enable = true;
      persistence = true;

      logDest = [
        "syslog"
        "topic"
      ];

      logType = [
        "error"
        "warning"
        "notice"
        "information"
      ];

      settings = {
        log_timestamp = true;
      };

      listeners = [
        {
          inherit port;
          address = "0.0.0.0";

          users = {
            mqtt_client = {
              passwordFile = config.sops.secrets."mosquitto/password/mqtt_client".path;
              acl = [ "read #" ];
            };

            homeassistant = {
              passwordFile = config.sops.secrets."mosquitto/password/homeassistant".path;
              acl = [
                "read $SYS/#"
                "readwrite zigbee2mqtt/#"
                "readwrite homeassistant/#"
              ];
            };

            zigbee2mqtt = {
              passwordFile = config.sops.secrets."mosquitto/password/zigbee2mqtt".path;
              acl = [
                "readwrite zigbee2mqtt/#"
                "readwrite homeassistant/#"
              ];
            };

            nodered = {
              passwordFile = config.sops.secrets."mosquitto/password/nodered".path;
              acl = [
                "readwrite zigbee2mqtt/#"
                "readwrite homeassistant/#"
              ];
            };
          };
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}

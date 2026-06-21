{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.automation.zigbee2mqtt;
  mqttHost = lib.looniversity.network.serviceHandlerHost config "mosquitto";
  mqttPort = lib.looniversity.network.serviceHandlerMainPort config "mosquitto";
  adapterDev = "tty.sonoff";
  port = 8080;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.automation.zigbee2mqtt = {
    enable = mkEnableOption "zigbee2mqtt";
  };

  config = mkIf cfg.enable {
    sops.templates."zigbee2mqtt_env_file" = {
      content = ''
        ZIGBEE2MQTT_CONFIG_MQTT_PASSWORD=${config.sops.placeholder."mosquitto/password/zigbee2mqtt"}
        ZIGBEE2MQTT_CONFIG_ADVANCED_NETWORK_KEY=${config.sops.placeholder."zigbee2mqtt/network_key"}
      '';
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0660", OWNER="zigbee2mqtt", GROUP="zigbee2mqtt", SYMLINK+="${adapterDev}"
    '';

    services.zigbee2mqtt = {
      enable = true;
      settings = {
        permit_join = true;

        mqtt = {
          server = "mqtt://${mqttHost}:${toString mqttPort}";
          base_topic = "zigbee2mqtt";
          user = "zigbee2mqtt";
          client_id = "zigbee2mqtt";
        };

        serial = {
          port = "/dev/${adapterDev}";
          adapter = "zstack";
        };

        frontend = {
          enabled = true;
          inherit port;
          url = "https://zigbee.${config.looniversity.network.domainName}";
        };

        homeassistant = {
          enabled = true;
          experimental_event_entities = true;
          legacy_action_sensor = true;
        };

        advanced = {
          log_level = "info";
        };

        devices = "devices.yaml";
        groups = "groups.yaml";
      };
    };

    networking.firewall.allowedTCPPorts = [ port ];

    systemd.services.zigbee2mqtt = {
      requires = [ "mosquitto.service" ];
      after = [ "mosquitto.service" ];
      serviceConfig = {
        EnvironmentFile = config.sops.templates."zigbee2mqtt_env_file".path;
      };
    };

    services.caddy = {
      virtualHosts = {
        "zigbee.${config.looniversity.network.domainName}" = {
          useACMEHost = "${config.looniversity.network.domainName}";

          logFormat = ''
            output file /var/log/caddy/access-zigbee.looniversity.net.log {
              mode 644
            }
          '';

          extraConfig = ''
            reverse_proxy http://127.0.0.1:8080
          '';
        };
      };
    };
  };
}

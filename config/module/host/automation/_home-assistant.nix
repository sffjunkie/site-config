{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.automation.home-assistant;
  postgresqlHost = lib.looniversity.network.serviceHandlerHost config "postgresql";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.automation.home-assistant = {
    enable = mkEnableOption "home-assistant";
  };

  config = mkIf cfg.enable {
    sops.templates."secret.yaml" = {
      content = ''
        latitude: ${config.sops.placeholder."hass/latitude"}
        longitude: ${config.sops.placeholder."hass/longitude"}
        elevation: ${config.sops.placeholder."hass/elevation"}
      '';
    };

    looniversity.db.postgresql.hostDatabases = {
      "${postgresqlHost}" = [ "homeassistant" ];
    };

    services.home-assistant = {
      enable = true;

      config = {
        default_config = { };
        ios = { };
        automation = "!include automations.yaml";
        sensor = "!include sensors.yaml";
        scene = "!include scenes.yaml";
        script = "!include scripts.yaml";

        homeassistant = {
          name = "Home";
          latitude = "!secret latitude";
          longitude = "!secret longitude";
          elevation = "!secret elevation";
          temperature_unit = "C";
          unit_system = "metric";
          time_zone = "UTC";
        };

        http = {
          server_host = "0.0.0.0";
          server_port = 8123;
          use_x_forwarded_for = true;
          trusted_proxies = "10.44.0.0/21";
        };

        recorder = {
          db_url = "!secret postgres_connection";
          exclude = {
            entities = [
              "sun.sun"
              "sensor.new_delhi"
              "sensor.new_york"
              "sensor.san_francisco"
              "sensor.time"
              "sensor.date"
            ];
          };
        };

        frontend = {
          themes = "!include_dir_merge_named themes";
        };
      };
    };
  };
}

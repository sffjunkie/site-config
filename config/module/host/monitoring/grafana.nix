# ports: 27017 - 27020
{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.monitoring.grafana;
  host = lib.looniversity.network.serviceHandlerHost config "grafana";
  port = lib.looniversity.network.serviceHandlerMainPort config "grafana";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.monitoring.grafana = {
    enable = mkEnableOption "grafana";
  };

  config = mkIf cfg.enable {
    sops.templates."grafana_secret_key_file" = {
      content = config.sops.placeholder."grafana/secret_key";
      owner = "grafana";
    };

    services.grafana = {
      enable = true;
      settings = {
        security = {
          secret_key = "$__file{${config.sops.templates.grafana_secret_key_file.path}}";
        };

        server = {
          domain = "grafana.${lib.looniversity.network.domainName config}";
          http_port = port;
          http_addr = host;
        };

        analytics = {
          reporting_enabled = false;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.network.service.reverse_proxy.caddy;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.network.service.reverse_proxy.caddy = {
    enable = mkEnableOption "Caddy Reverse Proxy";
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;

      globalConfig = ''
        metrics
      '';
    };

    services.prometheus = {
      scrapeConfigs = [
        {
          job_name = "caddy";
          scrape_interval = "15s";
          static_configs = [
            {
              targets = [ "localhost:2019" ];
            }
          ];
        }
      ];
    };

    looniversity.monitoring.alloy.pathTargets = [ "/var/log/caddy/*.log" ];

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}

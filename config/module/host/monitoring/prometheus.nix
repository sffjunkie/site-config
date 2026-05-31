{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.monitoring.prometheus;
  port = lib.looniversity.network.serviceHandlerMainPort config "prometheus";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.monitoring.prometheus = {
    enable = mkEnableOption "prometheus";
  };

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      inherit port;

      extraFlags = [
        "--web.enable-remote-write-receiver"
      ];

      scrapeConfigs = [
        # Scrape internal prometheus stats
        {
          job_name = "prometheus";
          scrape_interval = "5s";
          static_configs = [
            {
              targets = [ "localhost:${toString port}" ];
            }
          ];
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}

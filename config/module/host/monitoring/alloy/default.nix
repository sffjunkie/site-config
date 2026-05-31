{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.monitoring.alloy;
  port = lib.looniversity.network.serviceHandlerMainPort config "alloy";
  lokiHost = lib.looniversity.network.serviceHandlerHost config "loki";
  lokiPort = lib.looniversity.network.serviceHandlerMainPort config "loki";
  prometheusHost = lib.looniversity.network.serviceHandlerHost config "prometheus";
  prometheusPort = lib.looniversity.network.serviceHandlerMainPort config "prometheus";

  loki = ''
    loki.write "looniversity" {
        endpoint {
            url = "http://${lokiHost}:${toString lokiPort}/loki/api/v1/push"
        }
    }
  '';

  prometheus = ''
    prometheus.remote_write "looniversity" {
      endpoint {
        url = "http://${prometheusHost}:${toString prometheusPort}/api/v1/write"
      }
    }
  '';

  logs = pkgs.callPackage ./_logs.nix {
    inherit config lib;
    inherit (config.looniversity.monitoring.alloy) node;
  };
  metrics = pkgs.callPackage ./_metrics.nix {
    inherit config lib;
    inherit (config.looniversity.monitoring.alloy) node;
  };

  configDebugging = ''
    livedebugging{}
  '';

  alloyConfigElems = [
    loki
    prometheus
    logs
    metrics
  ]
  ++ lib.optional cfg.livedebug configDebugging;

  alloyConfig = lib.concatStringsSep "\n" alloyConfigElems;

  configFile = pkgs.writeTextFile {
    name = "alloy_config";
    text = alloyConfig;
  };

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.monitoring.alloy = {
    enable = mkEnableOption "alloy";

    node = mkOption {
      type = types.str;
      default = config.networking.hostName;
    };

    exposeUI = mkOption {
      type = types.bool;
      default = false;
      description = "If true expose the alloy UI to the network";
    };

    livedebug = mkOption {
      type = types.bool;
      default = false;
      description = "Enable live debugging";
    };
  };

  config = mkIf cfg.enable {
    services.alloy = {
      enable = true;
      configPath = "${toString configFile}";
      extraFlags = lib.optional cfg.exposeUI [
        "--server.http.listen-addr=0.0.0.0:${toString port}"
      ];
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}

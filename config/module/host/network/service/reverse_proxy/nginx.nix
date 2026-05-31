{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.network.service.reverse_proxy.nginx;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.network.service.reverse_proxy.nginx = {
    enable = mkEnableOption "Reverse Proxy";
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;

      virtualHosts = {
        "zigbee.${config.looniversity.network.domainName}" = {
          forceSSL = true;
          useACMEHost = "${config.looniversity.network.domainName}";
          locations."/".proxyPass = "http://thebrain:8080";
        };
      };
    };
  };
}

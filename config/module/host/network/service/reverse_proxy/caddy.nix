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
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}

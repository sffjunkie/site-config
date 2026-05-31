{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.network.service.wireguard;
  port = lib.looniversity.network.serviceHandlerMainPort config "wireguard";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.network.service.wireguard = {
    enable = mkEnableOption "Wireguard";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.wireguard-tools
    ];

    networking.firewall.interfaces.wan.allowedUDPPorts = [ port ];

    networking.wireguard.interfaces = {
      wg0 = {
        ips = [ "10.50.0.1/24" ];

        listenPort = port;

        privateKeyFile = config.sops.secrets."wireguard/server/private_key".path;

        peers = [
          {
            publicKey = "KiKUDMFNPA5wFSQ79FFoVnFiiBN1PYq6K1OCO6zSEjY=";
            allowedIPs = [ "10.50.0.2/32" ];
          }
        ];
      };
    };
  };
}

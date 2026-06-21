{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.service.netbox;

  netboxHost = "netbox.${config.looniversity.network.domainName}";
  netboxPort = 9001;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.netbox = {
    enable = mkEnableOption "netbox";
  };

  config = mkIf cfg.enable {
    sops.secrets."netbox/secret_key".owner = "netbox";
    sops.secrets."netbox/secret_key".group = "netbox";
    sops.secrets."netbox/password".owner = "netbox";
    sops.secrets."netbox/password".group = "netbox";
    sops.secrets."netbox/api_token_pepper".owner = "netbox";
    sops.secrets."netbox/api_token_pepper".group = "netbox";

    services.netbox = {
      enable = true;
      port = netboxPort;
      listenAddress = "0.0.0.0";
      package = pkgs.netbox;
      secretKeyFile = config.sops.secrets."netbox/secret_key".path;
      apiTokenPeppersFile = config.sops.secrets."netbox/api_token_pepper".path;

      settings = {
        CSRF_TRUSTED_ORIGINS = [
          "http://furrball.looniversity.net"
          "http://localhost"
        ];

        AUTH_PASSWORD_VALIDATORS = [ ];
      };
    };

    services.caddy = {
      enable = true;

      virtualHosts = {
        "netbox.looniversity.net" = {
          logFormat = ''
            output file /var/log/caddy/access-netbox.looniversity.net.log {
              mode 644
            }
          '';

          extraConfig = ''
            handle @static {
              file_server
              root /var/lib/netbox/static
            }

            # Handle all other requests by forwarding them to NetBox
            handle @app {
              reverse_proxy localhost:${toString netboxPort}
            }
          '';
        };
      };
    };

    looniversity.db.postgresql.hostDatabases.furrball = [ "netbox" ];

    networking.firewall.allowedTCPPorts = [ port ];
  };
}

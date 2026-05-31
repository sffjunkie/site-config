{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.service.forgejo;

  git_fqdn = lib.looniversity.network.serviceFQDN config "git";
  http_port = lib.looniversity.network.serviceHandlerMainPort config "forgejo";
  postgresql_fqdn = lib.looniversity.network.serviceHandlerFQDN config "postgresql";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.forgejo = {
    enable = mkEnableOption "forgejo";
  };

  config = mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      lfs.enable = true;

      database = {
        type = "postgres";
        host = postgresql_fqdn;
        user = "forgejo";
        passwordFile = config.sops.secrets."forgejo/db_password".path;
      };

      settings = {
        DEFAULT.APP_NAME = "Looniversity forgejo server";
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "https://${git_fqdn}";
        };

        server = {
          DOMAIN = git_fqdn;
          HTTP_PORT = http_port;
          DISABLE_REGISTRATION = true;
          COOKIE_SECURE = true;
          PROTOCOL = "http";

          SSH_DOMAIN = config.looniversity.network.domainName;
          SSH_PORT = lib.elemAt config.services.openssh.ports 0;
        };

        service.DISABLE_REGISTRATION = true;
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts = {
        "${git_fqdn}" = {
          extraConfig = ''
            reverse_proxy http://:${toString http_port}
          '';
        };
      };
    };

    looniversity.db.postgresql.hostDatabases.furrball = [ "forgejo" ];
  };
}

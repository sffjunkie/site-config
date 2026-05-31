{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.service.acme;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.acme = {
    enable = mkEnableOption "acme";
  };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "sffjunkie@gmail.com";
        # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      };

      certs = {
        "${config.looniversity.network.domainName}" = {
          domain = "${config.looniversity.network.domainName}";
          extraDomainNames = [
            "*.${config.looniversity.network.domainName}"
            "*.service.${config.looniversity.network.domainName}"
          ];

          dnsProvider = "cloudflare";
          credentialFiles = {
            "CF_DNS_API_TOKEN_FILE" = config.sops.secrets."cloudflare/looniversity_dns_api_token".path;
            "CF_ZONE_API_TOKEN_FILE" = config.sops.secrets."cloudflare/looniversity_zone_api_token".path;
          };
        };
      };
    };
  };
}

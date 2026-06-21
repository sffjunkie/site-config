{ config, ... }:
{
  config = {
    sops.templates."nix_site_secret_conf" = {
      content = ''
        access-tokens = github.com/sffjunkie/site-secrets=${config.sops.placeholder."github/site-secret"}
      '';
    };

    environment.etc."nix/nix.site-secret.conf" = {
      source = config.sops.templates."nix_site_secret_conf".path;
      mode = "0444";
    };
  };
}

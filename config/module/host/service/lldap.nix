{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.service.lldap;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.lldap = {
    enable = mkEnableOption "lldap";
  };

  config = mkIf cfg.enable {
    sops.templates."lldap_env_file" = {
      content = ''
        LLDAP_KEY_SEED=${config.sops.placeholder."lldap/key_seed"}
        LLDAP_JWT_SECRET=${config.sops.placeholder."lldap/jwt"}
      '';
    };

    services.lldap = {
      enable = true;

      settings = {
        ldap_portt = 6389;
        http_url = "https://ldap.looniversity.net";
        ldap_base_dn = config.looniversity.network.ldapBaseDN;
        database_url = "sqlite:////var/lib/lldap/lldap.db?mode=rwc";
        ldap_user_dn = "siteadmin";
        ldap_user_email = "sdk@looniversity.lan";
        ldap_user_pass_file = config.sops.secrets."lldap/admin_password".path;
        force_ldap_user_pass_reset = "always";
      };

      environmentFile = config.sops.templates."lldap_env_file".path;
    };

    networking.firewall.interfaces = {
      lan = {
        allowedTCPPorts = [ config.services.lldap.settings.ldap_port ];
      };
    };
  };
}

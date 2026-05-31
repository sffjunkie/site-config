{
  pkgs,
  config,
  lib,
  ...
}:
let
  baseDN = config.looniversity.network.ldapBaseDN;
  cfg = config.looniversity.service.openldap;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.openldap = {
    enable = mkEnableOption "OpenLDAP";
  };

  config = {

    services.openldap = mkIf cfg.enable {
      enable = true;

      settings.attrs.olcLogLevel = "0";

      settings.children = {
        "cn=module" = {
          attrs = {
            objectClass = "olcModuleList";
            olcModulePath = "${pkgs.openldap}/lib/modules";
            olcModuleLoad = [
              "argon2"
              "memberof"
              "syncprov"
            ];
          };
        };

        "cn=schema".includes = [
          "${pkgs.openldap}/etc/schema/core.ldif"
          "${pkgs.openldap}/etc/schema/cosine.ldif"
          "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
          "${pkgs.openldap}/etc/schema/nis.ldif"
        ];

        "olcDatabase={-1}frontend".attrs = {
          objectClass = [
            "olcDatabaseConfig"
            "olcFrontendConfig"
          ];
          olcDatabase = "{-1}frontend";
          olcPasswordHash = "{ARGON2}";
        };

        "olcDatabase={1}mdb".attrs = {
          objectClass = [
            "olcDatabaseConfig"
            "olcMdbConfig"
          ];
          olcDatabase = "{1}mdb";
          olcDbDirectory = "/var/lib/openldap/data";
          olcRootPW.path = config.sops.secrets.openldap-rootpw.path;
          olcRootDN = "cn=admin,${baseDN}";
          olcSuffix = "${baseDN}";
          olcAccess = [
            # Allow admins full write access to everything
            ''
              {0}to *
                by group.exact="cn=admins,ou=groups,${baseDN}" write
                by * break''
            ''
              {1}to attrs=userPassword
                by self write  by anonymous auth
                by dn.base="cn=authelia,ou=system,ou=users,${baseDN}" write
                by dn.base="cn=ldapsync,ou=system,ou=users,${baseDN}" read
                by * none''
            "{2}to attrs=loginShell  by self write  by users read"
            ''
              {3}to dn.subtree="ou=users,${baseDN}" attrs=mail,mailbox,maildrop,quota,cn,objectClass,memberOf
                by dn.base="cn=postfix,ou=system,ou=users,${baseDN}" read
                by dn.base="cn=dovecot,dc=mail,${baseDN}" read
                by dn.base="cn=vaultwarden-ldap,ou=system,ou=users,${baseDN}" read
                by dn.base="cn=phpldapadmin,ou=system,ou=users,${baseDN}" read
                by users read
                by * none''
            ''
              {4}to dn.subtree="ou=system,ou=users,${baseDN}"
                by dn.base="cn=dovecot,dc=mail,${baseDN}" read
                by dn.base="cn=nextcloud,ou=system,ou=users,${baseDN}" read
                by dn.subtree="ou=system,ou=users,${baseDN}" read
                by * none''
            ''
              {5}to *
                by users read
                by * none''
          ];
        };
        "olcOverlay={0}memberof,olcDatabase={1}mdb".attrs = {
          objectClass = [
            "olcOverlayConfig"
            "olcMemberOf"
          ];
          olcOverlay = "{0}memberof";
          olcMemberOfRefInt = "TRUE";
          olcMemberOfGroupOC = "groupOfNames";
          olcMemberOfMemberAD = "member";
          olcMemberOfMemberOfAD = "memberOf";
        };
        "olcOverlay={1}syncprov,olcDatabase={1}mdb".attrs = {
          objectClass = [
            "olcOverlayConfig"
            "olcSyncProvConfig"
          ];
          olcOverlay = "{1}syncprov";
          olcSpSessionLog = "100";
        };
        "olcDatabase={2}monitor".attrs = {
          olcDatabase = "{2}monitor";
          objectClass = [
            "olcDatabaseConfig"
            "olcMonitorConfig"
          ];
          olcAccess = [
            ''
              {0}to *
                by dn.exact="cn=netdata,ou=system,ou=users,${baseDN}" read
                by * none''
          ];
        };
        "cn={1}prometheus,cn=schema".attrs = {
          cn = "{1}prometheus";
          objectClass = "olcSchemaConfig";
          olcObjectClasses = [
            ''
              (1.3.6.1.4.1.28296.1.2.4
                NAME 'prometheus'
                SUP uidObject AUXILIARY
                DESC 'Added to an account to allow prometheus access'
                MUST (mail))
            ''
          ];
        };
        "cn={1}loki,cn=schema".attrs = {
          cn = "{1}loki";
          objectClass = "olcSchemaConfig";
          olcObjectClasses = [
            ''
              (1.3.6.1.4.1.28299.1.2.4
                NAME 'loki'
                SUP uidObject AUXILIARY
                DESC 'Added to an account to allow loki access'
                MUST (mail))
            ''
          ];
        };

      };
    };

    sops.secrets.openldap-rootpw.owner = "openldap";

    networking.firewall.interfaces.allowedTCPPorts = [ 389 ];
  };
}

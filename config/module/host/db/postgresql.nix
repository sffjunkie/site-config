{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.db.postgresql;
  pgPackage = lib.looniversity.network.serviceServiceHandlerPackage config "postgresql";

  databases = lib.attrByPath [
    config.networking.hostName
  ] null config.looniversity.db.postgresql.hostDatabases;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.db.postgresql = {
    enable = mkEnableOption "postgresql";

    hostDatabases = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = { };
      example = ''
        { host = [ "dbname" ]; }
      '';
      description = ''
        An attrset of databases to create, with an attr for each db host.
        Each db host will contain a list of database names.

        For each database a user will be created name the same
        as the database.
        Can be set in each individual service configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      5432
    ];

    services.postgresql = {
      enable = lib.mkForce (databases != null);
      package = lib.mkForce pgPackage;

      enableTCPIP = true;

      ensureDatabases = databases;
      ensureUsers =
        (map (elem: {
          name = toString elem;
          ensureDBOwnership = true;
        }) databases)
        ++ [
          {
            name = "sysadmin";
            ensureClauses = {
              createdb = true;
              login = true;
            };
          }
          {
            name = "dbadmin";
            ensureClauses = {
              createdb = true;
              createrole = true;
              login = true;
            };
          }
        ];

      authentication = ''
        host    all     all       0.0.0.0/0       scram-sha-256
      '';

      settings = {
        password_encryption = "scram-sha-256";
      };
    };
  };
}

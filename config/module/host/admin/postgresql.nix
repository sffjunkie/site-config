{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.admin.postgresql;

  port = lib.looniversity.tool.getToolPort config "postgresql-admin";
  pgPackage = lib.looniversity.network.serviceServiceHandlerPackage config "postgresql";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.admin.postgresql = {
    enable = mkEnableOption "postgresql admin";
  };

  config = mkIf cfg.enable {
    services.postgresql.package = pgPackage;

    services.pgadmin = {
      enable = true;
      inherit port;

      initialEmail = "siteadmin@looniversity.lan";
      initialPasswordFile = config.sops.secrets."pgadmin/initial_password".path;
    };
  };
}

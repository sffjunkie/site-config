{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.service.nextcloud;

  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.service.nextcloud = {
    enable = mkEnableOption "nextcloud";
  };

  config = mkIf cfg.enable {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "cloud.looniversity.net";

      autoUpdateApps = enabled // {
        startAt = "05:00:00";
      };

      settings = {
        overwriteprotocol = "https";
      };

      config = {
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
        dbpassFile = config.sops.secrets."nextcloud/db_password".path;

        adminpassFile = config.sops.secrets."nextcloud/admin_password".path;
      };
    };

    looniversity.db.postgresql = {
      enable = true;
      hostDatabases.thebrain = [ config.services.nextcloud.config.dbname ];
    };
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.storage.garage;

  listenPort = lib.looniversity.network.serviceHandlerNamedPort config "garage" "listen";
  consolePort = lib.looniversity.network.serviceHandlerNamedPort config "garage" "console";

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.storage.garage = {
    enable = mkEnableOption "garage";

    dataDir = mkOption {
      default = [ "/var/lib/minio/data" ];
      type = types.listOf (types.either types.path types.str);
      description = lib.mdDoc "The list of data directories or nodes for storing the objects. Use one path for regular operation and the minimum of 4 endpoints for Erasure Code mode.";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "minio/root_user" = {
        owner = config.users.users.minio.name;
        sopsFile = config.site.paths.secrets.site.service;
      };
      "minio/root_password" = {
        owner = config.users.users.minio.name;
        sopsFile = config.site.paths.secrets.site.service;
      };
    };

    sops.templates."minio_env_file" = {
      content = ''
        MINIO_ROOT_USER=${config.sops.placeholder."minio/root_user"}
        MINIO_ROOT_PASSWORD=${config.sops.placeholder."minio/root_password"}
      '';
      owner = config.users.users.minio.name;
    };

    services.minio = {
      inherit (config.looniversity.storage.minio) dataDir;

      enable = true;
      listenAddress = ":${toString listenPort}";
      consoleAddress = ":${toString consolePort}";
      rootCredentialsFile = config.sops.templates."minio_env_file".path;
    };

    networking.firewall.allowedTCPPorts = [
      listenPort
      consolePort
    ];
  };
}

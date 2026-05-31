{
  config,
  ...
}:
{
  config = {
    sops.templates."furrball_nas_env_file" = {
      content = ''
        AWS_DEFAULT_REGION="us-east-1"
        AWS_ACCESS_KEY_ID=${config.sops.placeholder."restic/s3_access_key"}
        AWS_SECRET_ACCESS_KEY=${config.sops.placeholder."restic/s3_secret_key"}
      '';
    };

    services.restic.backups.furrball_nas = {
      initialize = true;
      paths = [
        "/var/lib"
      ];
      repository = "s3:https://s3.service.looniversity.net/restic-furrball";
      passwordFile = config.sops.secrets."restic/repositories/furrball/s3/password".path;

      environmentFile = config.sops.templates."furrball_nas_env_file".path;
    };
  };
}

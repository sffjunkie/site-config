{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.storage.minio-client;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.storage.minio-client = {
    enable = mkEnableOption "minio-client";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.minio-client
    ];
  };
}

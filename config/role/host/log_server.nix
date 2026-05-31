{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.log_server;

  inherit (lib) mkEnableOption mkIf;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.role.log_server = {
    enable = mkEnableOption "log server role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      monitoring = {
        grafana = enabled;
        loki = enabled;
        prometheus = enabled;
      };
    };
  };
}

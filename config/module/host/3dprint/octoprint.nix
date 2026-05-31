{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.print3d.octoprint;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.print3d.octoprint = {
    enable = mkEnableOption "Octoprint";
  };

  config = mkIf cfg.enable {
    services.octoprint = {
      enable = true;
    };
  };
}

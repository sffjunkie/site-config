{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.automation.matter;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.automation.matter = {
    enable = mkEnableOption "matter";
  };

  config = mkIf cfg.enable {
    services.matter-server = {
      enable = true;
      openFirewall = true;
    };
  };
}

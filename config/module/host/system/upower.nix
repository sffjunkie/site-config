{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.system.upower;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.looniversity.system.upower = {
    enable = mkEnableOption "upower";
  };

  config = mkIf cfg.enable {
    services.upower = {
      enable = true;
    };
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.gui.walker;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.walker = {
    enable = mkEnableOption "walker";
  };

  config = mkIf cfg.enable {
    services.walker.enable = true;
  };
}

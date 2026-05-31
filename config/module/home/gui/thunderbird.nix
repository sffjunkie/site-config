{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.thunderbird;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.thunderbird = {
    enable = mkEnableOption "thunderbird";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.thunderbird
    ];
  };
}

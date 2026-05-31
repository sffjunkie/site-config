{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.gui.zathura;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.gui.zathura = {
    enable = mkEnableOption "zathura";
  };

  config = mkIf cfg.enable {
    programs.zathura = enabled;
  };
}

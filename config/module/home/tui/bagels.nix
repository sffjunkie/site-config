{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.tui.bagels;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.looniversity.tui.bagels = {
    enable = mkEnableOption "bagels";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.bagels
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.theme.stylix;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.theme.stylix = {
    enable = mkEnableOption "stylix";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.looniversity.theme.base16}.yaml";
    };
  };
}

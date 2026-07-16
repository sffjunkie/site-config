{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.theme.catppuccin;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.theme.catppuccin = {
    enable = mkEnableOption "catppuccin";
  };

  config = mkIf cfg.enable {
    catppuccin = {
      enable = true;
      autoEnable = true;

      flavor = config.looniversity.site.theme.catppuccin.flavor;
      accent = config.looniversity.site.theme.catppuccin.accent;

      cursors = {
        enable = true;
      };
    };
  };
}

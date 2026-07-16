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

      flavor = config.looniversity.user.theme.catppuccin.flavor;
      accent = config.looniversity.user.theme.catppuccin.accent;

      cursors = {
        enable = true;
      };

      kvantum = {
        enable = true;
        flavor = config.looniversity.user.theme.catppuccin.flavor;
        accent = config.looniversity.user.theme.catppuccin.accent;
      };
    };
    qt.style.name = "kvantum";
  };
}

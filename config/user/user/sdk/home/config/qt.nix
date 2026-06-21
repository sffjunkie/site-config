{ config, lib, ... }:
{
  config = {
    qt = {
      enable = true;
      kvantum.enable = true;

      platformTheme.name = "qtct";
      style.name = "kvantum";

      qt6ctSettings = {
        Appearance = {
          style = "kvantum";
          icon_theme = "Adwaita";
        };
        Fonts = {
          fixed = "JetBrainsMono Nerd Font,12";
          general = "JetBrainsMono Nerd Font,12";
        };
      };
    };
    # catppuccin.qt5ct.enable = true;
    catppuccin = {
      enable = true;
      qt5ct.enable = true;
      kvantum = {
        enable = true;
        flavor = config.looniversity.user.theme.catppuccin.flavor;
        accent = config.looniversity.user.theme.catppuccin.accent;
      };
    };
  };
}

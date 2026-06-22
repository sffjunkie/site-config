{ config, ... }:
let
  qtctSettings = {
    Appearance = {
      style = "kvantum";
      icon_theme = "Adwaita";
      standard_dialogs = "xdgdesktopportal";
    };
    Fonts = {
      fixed = "JetBrainsMono Nerd Font,13";
      general = "JetBrainsMono Nerd Font,13";
    };
  };
in
{
  config = {
    qt = {
      enable = true;

      platformTheme.name = "qtct";
      style.name = "kvantum";

      qt5ctSettings = qtctSettings;
      qt6ctSettings = qtctSettings;
    };

    catppuccin = {
      enable = true;
      kvantum = {
        enable = true;
        flavor = config.looniversity.user.theme.catppuccin.flavor;
        accent = config.looniversity.user.theme.catppuccin.accent;
      };
    };
  };
}

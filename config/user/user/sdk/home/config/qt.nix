{ config, ... }:
let
  contentFont = config.looniversity.user.theme.font.content;

  qtctSettings = {
    Appearance = {
      style = "kvantum";
      icon_theme = "Adwaita";
      standard_dialogs = "xdgdesktopportal";
    };
    Fonts = {
      fixed = "${contentFont.family},${toString contentFont.size}";
      general = "${contentFont.family},${toString contentFont.size}";
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

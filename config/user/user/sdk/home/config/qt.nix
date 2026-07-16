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

      qt5ctSettings = qtctSettings;
      qt6ctSettings = qtctSettings;
    };
  };
}

{
  config,
  formatter,
  ...
}:
formatter.generate "desktop-font" {
  font = {
    content = {
      family = config.looniversity.user.theme.font.content.family;
      size = 16;
    };
    ui = {
      family = config.looniversity.user.theme.font.ui.family;
      size = 16;
    };
    icon = {
      family = config.looniversity.user.theme.font.icon.family;
      size = 22;
    };
  };
}

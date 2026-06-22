{
  config,
  formatter,
  ...
}:
formatter.generate "desktop-font" {
  font = {
    content = {
      family = config.looniversity.user.theme.font.content.family;
      size = builtins.ceil (config.looniversity.user.theme.font.content.size * 1.33333);
    };
    ui = {
      family = config.looniversity.user.theme.font.ui.family;
      size = builtins.ceil (config.looniversity.user.theme.font.ui.size * 1.33333);
    };
    icon = {
      family = config.looniversity.user.theme.font.icon.family;
      size = builtins.ceil (config.looniversity.user.theme.font.icon.size * 1.33333 * 1.5);
    };
  };
}

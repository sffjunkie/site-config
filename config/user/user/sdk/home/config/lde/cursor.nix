{
  config,
  formatter,
  ...
}:
formatter.generate "desktop-cursor" {
  cursor = {
    name = config.looniversity.user.cursor.name;
    size = config.looniversity.user.cursor.size;
  };
}

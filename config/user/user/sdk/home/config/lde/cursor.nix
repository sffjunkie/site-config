{
  config,
  formatter,
  ...
}:
let
  cfg = config.looniversity.user.theme.cursor;
in
formatter.generate "desktop-cursor" {
  cursor = {
    name = if (cfg.name != null) then cfg.name else config.home.pointerCursor.name;
    size = if (cfg.size != -1) then cfg.size else config.home.pointerCursor.size;
  };
}

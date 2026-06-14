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
    package = if (cfg.name != null) then cfg.package else config.home.pointerCursor.package;
    name = if (cfg.name != null) then cfg.name else config.home.pointerCursor.name;
    size = if (cfg.size != -1) then cfg.size else config.home.pointerCursor.size;
  };
}

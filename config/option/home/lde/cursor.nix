{
  config,
  lib,
  ...
}:
let
  stylixCfg = config.stylix;

  inherit (lib) mkOption types;
in
{
  options.looniversity.user.cursor = {
    package = mkOption {
      description = "Cursor package";
      type = types.nullOr types.package;
      default = if stylixCfg.enable then config.stylix.cursor.package else null;
    };

    name = mkOption {
      description = "Cursor name";
      type = types.str;
      default = if stylixCfg.enable then config.stylix.cursor.name else "";
    };

    size = mkOption {
      description = "Cursor size";
      type = types.int;
      default = if stylixCfg.enable then config.stylix.cursor.size else 24;
    };
  };
}

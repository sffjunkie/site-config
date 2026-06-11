{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.looniversity.user.cursor = {
    package = mkOption {
      description = "Cursor package";
      type = types.nullOr types.package;
      default = null;
    };

    name = mkOption {
      description = "Cursor name";
      type = types.str;
      default = "";
    };

    size = mkOption {
      description = "Cursor size";
      type = types.int;
      default = 24;
    };
  };
}

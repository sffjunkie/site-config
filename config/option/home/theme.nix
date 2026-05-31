{
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.looniversity.theme = {
    base16 = mkOption {
      type = types.str;
      default = osConfig.looniversity.theme.base16;
      description = "User base16 color scheme";
    };
  };
}

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

    catppuccin = {
      flavor = mkOption {
        type = types.str;
        default = osConfig.looniversity.theme.catppuccin.flavor;
      };

      accent = mkOption {
        type = types.str;
        default = osConfig.looniversity.theme.catppuccin.accent;
      };
    };

    lockscreen = {
      image = mkOption {
        type = types.nullOr types.path;
        default = null;
      };
    };
  };
}

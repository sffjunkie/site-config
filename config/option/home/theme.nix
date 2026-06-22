{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;

  fontDef = types.submodule {
    options = {
      family = mkOption {
        type = types.str;
        default = "JetBrainsMono Nerd Font";
      };
      size = mkOption {
        type = types.int;
        default = 12; # pt
      };
      package = mkOption {
        type = types.package;
        default = pkgs.nerd-fonts.jetbrains-mono;
      };
    };
  };
in
{
  options.looniversity.user.theme = {
    base16 = mkOption {
      type = types.str;
      default = osConfig.looniversity.site.theme.base16;
      description = "User base16 color scheme";
    };

    catppuccin = {
      flavor = mkOption {
        type = types.str;
        default = osConfig.looniversity.site.theme.catppuccin.flavor;
        description = "catppuccin flavor";
      };

      accent = mkOption {
        type = types.str;
        default = osConfig.looniversity.site.theme.catppuccin.accent;
        description = "catppuccin accent color";
      };
    };

    cursor = {
      package = mkOption {
        description = "Cursor package";
        type = types.nullOr types.package;
        default = null;
      };

      name = mkOption {
        description = "Cursor name";
        type = types.nullOr types.str;
        default = null;
      };

      size = mkOption {
        description = "Cursor size";
        type = types.int;
        default = -1;
      };
    };

    font = {
      content = mkOption {
        type = fontDef;
      };

      ui = mkOption {
        type = fontDef;
      };

      icon = mkOption {
        type = fontDef;
      };
    };

    lockscreen = {
      image = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "lock screen background image";
      };
    };
  };
}

{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.looniversity.site.theme = {
    base16 = mkOption {
      type = types.str;
      description = "Site wide base16 color scheme";
    };

    catppuccin = {
      flavor = mkOption {
        type = types.str;
        description = "catppuccin flavor";
      };

      accent = mkOption {
        type = types.str;
        description = "catppuccin accent color";
      };
    };
  };
}

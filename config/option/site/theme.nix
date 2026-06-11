{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.looniversity.theme = {
    base16 = mkOption {
      type = types.str;
      description = "Site wide base16 color scheme";
      default = "catppuccin-macchiato";
    };

    catppuccin = {
      flavor = mkOption {
        type = types.str;
        default = "macchiato";
      };

      accent = mkOption {
        type = types.str;
        default = "teal";
      };
    };
  };
}

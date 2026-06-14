let
  flavor = "macchiato";
  accent = "yellow";
in
{
  config = {
    looniversity.site.theme = {
      base16 = "catppuccin-${flavor}";
      catppuccin = {
        flavor = flavor;
        accent = accent;
      };
    };
  };
}

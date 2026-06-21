{
  config,
  formatter,
  pkgs,
  ...
}:
formatter.generate "desktop-color" {
  color = {
    base16 = {
      scheme_name = config.looniversity.user.theme.base16;
      scheme_dir = "${pkgs.base16-schemes}/share/themes";
    };
  };
}

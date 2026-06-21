{
  formatter,
  pkgs,
  ...
}:
formatter.generate "desktop-font" {
  font = {
    text = {
      family = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
      size = 16;
    };
    ui = {
      family = "JetBrainsMono Nerd Font";
      size = 16;
    };
    icon = {
      family = "Material Design Icons";
      package = pkgs.material-design-icons;
      size = 22;
    };
    weather = {
      family = "Hack Nerd Font";
      package = pkgs.nerd-fonts.hack;
      size = 22;
    };
    logo = {
      family = "Hack Nerd Font";
      package = pkgs.nerd-fonts.hack;
      size = 22;
    };
  };
}

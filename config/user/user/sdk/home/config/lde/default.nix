{
  config,
  lib,
  pkgs,
  ...
}:
let
  config_dir = "lde";
  format = "toml";

  formatter = (lib.getAttr format pkgs.formats) { };
  args = { inherit config formatter; };

  app = pkgs.callPackage ./app.nix args;
  bar = pkgs.callPackage ./bar.nix args;
  branding = pkgs.callPackage ./branding.nix args;
  color = pkgs.callPackage ./color.nix args;
  controller = pkgs.callPackage ./controller.nix args;
  cursor = pkgs.callPackage ./cursor.nix args;
  device = pkgs.callPackage ./device.nix args;
  floating = pkgs.callPackage ./floating.nix args;
  font = pkgs.callPackage ./font.nix args;
  group = pkgs.callPackage ./group.nix args;
  input = pkgs.callPackage ./input.nix args;
  key = pkgs.callPackage ./key.nix args;
  layout = pkgs.callPackage ./layout.nix args;
  match = pkgs.callPackage ./match.nix args;
  menu = pkgs.callPackage ./menu.nix args;
  notifier = pkgs.callPackage ./notifier.nix args;
in
{
  config = {
    xdg.configFile."${config_dir}/app.${format}".source = app;
    xdg.configFile."${config_dir}/bar.${format}".source = bar;
    xdg.configFile."${config_dir}/branding.${format}".source = branding;
    xdg.configFile."${config_dir}/color.${format}".source = color;
    xdg.configFile."${config_dir}/controller.${format}".source = controller;
    xdg.configFile."${config_dir}/cursor.${format}".source = cursor;
    xdg.configFile."${config_dir}/device.${format}".source = device;
    xdg.configFile."${config_dir}/floating.${format}".source = floating;
    xdg.configFile."${config_dir}/font.${format}".source = font;
    xdg.configFile."${config_dir}/group.${format}".source = group;
    xdg.configFile."${config_dir}/input.${format}".source = input;
    xdg.configFile."${config_dir}/key.${format}".source = key;
    xdg.configFile."${config_dir}/layout.${format}".source = layout;
    xdg.configFile."${config_dir}/match.${format}".source = match;
    xdg.configFile."${config_dir}/menu.${format}".source = menu;
    xdg.configFile."${config_dir}/notifier.${format}".source = notifier;
  };
}

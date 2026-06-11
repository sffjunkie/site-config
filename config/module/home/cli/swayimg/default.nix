{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.swayimg;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.swayimg = {
    enable = mkEnableOption "swayimg";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.swayimg
    ];

    xdg.configFile."swayimg/init.lua".source = ./init.lua;

    # programs.zsh.shellAliases = {
    #   feh = "feh -Tdefault";
    #   fehs = "feh -Tslideshow";
    # };
  };
}

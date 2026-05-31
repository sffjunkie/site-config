{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.cli.dircolors;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.dircolors = {
    enable = mkEnableOption "dircolors";
  };

  config = mkIf cfg.enable {
    programs.dircolors = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.cli.zoxide;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.zoxide = {
    enable = mkEnableOption "zoxide";
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh.shellAliases = {
      cd = "z";
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.worktrunk;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.cli.worktrunk = {
    enable = mkEnableOption "worktrunk";

    enableZshIntegration = mkOption {
      type = types.bool;
      default = config.programs.zsh.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.worktrunk
    ];

    programs.zsh.initContent = lib.mkIf cfg.enableZshIntegration ''
      if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
    '';
  };
}

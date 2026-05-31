{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.development.direnv;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.development.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    programs.direnv = enabled // {
      nix-direnv = enabled;
    };
  };
}

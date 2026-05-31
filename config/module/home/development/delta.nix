{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.development.delta;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.development.delta = {
    enable = mkEnableOption "delta";
  };

  config = mkIf cfg.enable {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;

      options = {
        navigate = true;
        dark = true;
        side-by-side = true;
        merge.conflictStyle = "zdiff3";
      };
    };
  };
}

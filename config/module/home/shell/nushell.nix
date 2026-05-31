{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.shell.nushell;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.shell.nushell = {
    enable = mkEnableOption "nushell";
  };

  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
    };
  };
}

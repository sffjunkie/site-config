{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.script.paths;
  inherit (lib) mkEnableOption mkIf;

  paths = pkgs.writeShellScriptBin "paths" ''
    [ -z $1 ] && echo $PATH | tr : '\n' || echo $1 | tr : '\n'
  '';
in
{
  options.looniversity.script.paths = {
    enable = mkEnableOption "paths";
  };

  config = mkIf cfg.enable {
    home.packages = [ paths ];
  };
}

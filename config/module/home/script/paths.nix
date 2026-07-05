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
    set -e
    set -u

    IFS=':' read -ra paths <<< "''${1:-''$PATH}"
    for i in "''${paths[@]}"
    do
      [ -d "$i" ] && echo "$i" || echo -e '\033[1;30m'"$i"'\033[0m'
    done
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

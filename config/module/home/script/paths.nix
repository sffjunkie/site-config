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

    print_path() {
      [ -d "$1" ] && echo "$1" || echo -e '\033[1;30m'"$1"'\033[0m'
    }

    IFS=':' read -ra paths <<< "''${1:-''$PATH}"
    for i in "''${paths[@]}"
    do
      print_path "$i"
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

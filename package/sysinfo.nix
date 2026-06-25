{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.script.sysinfo;
  inherit (lib) mkEnableOption mkIf;

  sysinfo = pkgs.writeShellScriptBin "sysinfo" ''
    width=$(tput cols)
    ${pkgs.figlet}/bin/figlet -w ''${width} "System Information"
    ${pkgs.fastfetch}/bin/fastfetch
  '';
in
{
  options.looniversity.script.sysinfo = {
    enable = mkEnableOption "sysinfo";
  };

  config = mkIf cfg.enable {
    home.packages = [ sysinfo ];
  };
}

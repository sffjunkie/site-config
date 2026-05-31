{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.network.tool.cli;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.network.tool.cli = {
    enable = mkEnableOption "networking tools";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.nftables
      pkgs.net-tools
      pkgs.bridge-utils
      pkgs.dig
      pkgs.nfs-utils
    ];

    programs.mtr.enable = true;

    environment.shellAliases = {
      dig = "dig @10.44.0.1";
    };
  };
}

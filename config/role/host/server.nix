{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.role.server;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.role.server = {
    enable = mkEnableOption "server role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      service.fail2ban = enabled;
      network.service.sshd = enabled;
    };

    networking = {
      nftables = enabled;
      firewall = {
        enable = true;
      };
    };

    environment.systemPackages = [
      pkgs.pinentry-curses
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  nft = "${pkgs.nftables}/bin/nft";
  flowtableScript = pkgs.writeShellScriptBin "firewall-flowtable.sh" ''
    ${nft} add flowtable inet filter f { hook ingress priority 0\; devices = { lan }\; }
    ${nft} add rule inet filter forward ip protocol { tcp, udp } flow offload @f
  '';

  inherit (lib) mkIf;
in
{
  config = mkIf config.looniversity.network.firewall.enable {
    systemd.services.firewall-flowtable-lan = {
      description = "nftables firewall flowtable for lan interface";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = [
          "${flowtableScript}/bin/firewall-flowtable.sh"
        ];
      };
    };
  };
}

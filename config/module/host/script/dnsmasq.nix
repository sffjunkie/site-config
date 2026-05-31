{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.script.dnsmasq;
  dnsmasqScript = pkgs.writeShellScriptBin "dnsmasq" ''
    # This is a dummy, will be called by virtlibd (dnsmasq --version)
    echo "Dnsmasq version 2.89"
    exit 0
  '';
in
{
  options.looniversity.script.dnsmasq = {
    enable = lib.mkEnableOption "dummy dnsmasq script for virtnetworkd";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      dnsmasqScript
    ];
  };
}

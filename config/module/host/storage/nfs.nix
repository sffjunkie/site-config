{
  config,
  lib,
  ...
}:
let
  statdPort = 4000;
  lockdPort = 4001;
  mountdPort = 4002;
  inherit (lib) mkIf;
in
{
  config = mkIf (config.looniversity.fs.nfs.exports != [ ]) {
    services.nfs = {
      server = {
        enable = true;
        inherit statdPort lockdPort mountdPort;
      };

      settings = {
        nfsd = {
          rdma = true; # Remote Direct Memory Access
          vers3 = false;
          vers4 = true;
          "vers4.0" = false;
          "vers4.1" = false;
          "vers4.2" = true;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      111
      2049
      statdPort
      lockdPort
      mountdPort
    ];
    networking.firewall.allowedUDPPorts = [
      111
      2049
      statdPort
      lockdPort
      mountdPort
    ];
  };
}

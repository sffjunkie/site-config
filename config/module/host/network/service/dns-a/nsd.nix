{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.network.service.dns-a;
  dnsPort = 53530;
  serial = 1;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.network.service.dns-a = {
    enable = mkEnableOption "Authoritative DNS";
  };

  config = mkIf cfg.enable {
    services.nsd = {
      enable = true;
      port = dnsPort;
      remoteControl.enable = true;

      zones = {
        "${config.looniversity.network.domainName}." = {
          data = ''
            $ORIGIN .
            $TTL 3600
            ${config.looniversity.network.domainName} IN SOA dns.${config.looniversity.network.domainName}. admin.${config.looniversity.network.domainName}. (
                ${toString serial}
                86400
                3600
                604800
                3600
              )
              NS dns.${config.looniversity.network.domainName}.

            $ORIGIN ${config.looniversity.network.domainName}.
            dns   A   10.44.0.1
          '';
        };
        "44.10.in-addr.arpa" = {
          data = ''
            $ORIGIN 44.10.in-addr.arpa.
            $TTL 3600
            @ IN SOA dns.${config.looniversity.network.domainName}. admin.${config.looniversity.network.domainName}. (
              ${toString serial}
              86400
              3600
              604800
              3600
            )

            1   IN PTR   dns.${config.looniversity.network.domainName}.
          '';
        };
      };
    };
  };
}

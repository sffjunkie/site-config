{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.network.service.dns-r;

  inherit (config.looniversity.network) vlans;
  vlanAccessControl = map (
    name:
    let
      vlanInfo = vlans.${name};

      vlanNetwork = lib.looniversity.ipv4.constructIpv4Address config.looniversity.network.networkAddress "${toString vlanInfo.id}.0";
      vlanPrefixLength = vlanInfo.prefixLength;
    in
    "${vlanNetwork}/${toString vlanPrefixLength} allow"
  ) (lib.attrNames vlans);

  dnsPort = 1053;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.network.service.dns-r = {
    enable = mkEnableOption "Recursive, caching dns";
  };

  config = mkIf cfg.enable {
    services.unbound = {
      enable = true;
      settings = {
        server = {
          port = dnsPort;
          prefer-ip4 = true;
          interface = "0.0.0.0";

          aggressive-nsec = true;
          qname-minimisation = true;
          tls-system-cert = true;
        };

        stub-zone = [
          {
            name = config.looniversity.network.domainName;
            stub-addr = "127.0.0.1@${toString config.services.nsd.port}";
          }
        ];

        forward-zone = [
          {
            name = ".";
            forward-addr = [
              "1.1.1.1@853#cloudflare-dns.com"
              "8.8.8.8@853#dns.google"
            ];
            forward-tls-upstream = true;
          }
        ];

        access-control = [
          "127.0.0.1/32 allow_snoop"
          "::1 allow_snoop"
          "127.0.0.0/8 allow"
          "2a00:23c8:41c0:6600::/64 allow"
          "::1/128 allow"
          "${config.looniversity.network.networkAddress}/${toString config.looniversity.network.prefixLength} allow"
        ]
        ++ vlanAccessControl;

        remote-control = {
          control-enable = true;
        };
      };
    };
  };
}

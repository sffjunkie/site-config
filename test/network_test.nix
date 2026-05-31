{ lib, pkgs, ... }:
let
  testData = {
    config = {
      looniversity.network = {
        networkAddress = "192.168.1.0";
        prefixLength = 21;
        domainName = "home.arpa";

        hosts = {
          host_a = {
            netDevice = {
              lan = {
                device = "eth1";
                ipv4 = "192.168.1.1";
                ipv4method = "dhcpstatic";
                mac = "48:d6:32:db:83:de";
              };
            };
          };
        };

        services = {
          ca.handler = "step-ca";
          cloud.handler = "nextcloud";
          mail = {
            domainName = "lan.arpa";
          };
        };

        serviceHandlers = {
          nextcloud = {
            host = "cloud";
            port = 80;
          };

          postgresql = {
            package = pkgs.postgresql_15;
            host = "192.168.1.1";
          };

          step-ca = {
            host = "bigbox";
            ports = {
              ui = 8080;
            };
          };
        };
      };
    };
  };
in
[
  {
    name = "domainName";
    actual = lib.looniversity.network.domainName testData.config;
    expected = "home.arpa";
  }
  {
    name = "network.netDeviceMAC";
    actual = lib.looniversity.network.netDeviceMAC testData.config "host_a" "lan";
    expected = "48:d6:32:db:83:de";
  }
  {
    name = "network.lanIpv4";
    actual = lib.looniversity.network.lanIpv4 testData.config "host_a";
    expected = "192.168.1.1";
  }
  {
    name = "network.lanIpv4.badHost";
    actual = lib.looniversity.network.lanIpv4 testData.config "host_b";
    expected = null;
  }
  {
    name = "network.service";
    actual = lib.looniversity.network.service testData.config "cloud";
    expected = {
      "handler" = "nextcloud";
    };
  }
  {
    name = "network.serviceFQDN";
    actual = lib.getAttr "handler" (lib.looniversity.network.service testData.config "cloud");
    expected = "nextcloud.looniversity.net";
  }
  {
    name = "network.serviceHandler";
    actual = lib.looniversity.network.serviceHandler testData.config "nextcloud";
    expected = {
      host = "cloud";
      port = 80;
    };
  }
  {
    name = "network.serviceHandler.nonexistent";
    actual = lib.looniversity.network.serviceHandler testData.config "aservice";
    expected = { };
  }
  {
    name = "network.serviceHandlerMainPort";
    actual = lib.looniversity.network.serviceHandlerMainPort testData.config "nextcloud";
    expected = 80;
  }
  {
    name = "network.serviceHandlerNamedPort";
    actual = lib.looniversity.network.serviceHandlerNamedPort testData.config "step-ca" "ui";
    expected = 8080;
  }
  {
    name = "network.serviceHandlerHost";
    actual = lib.looniversity.network.serviceHandlerHost testData.config "nextcloud";
    expected = "cloud";
  }
  {
    name = "network.serviceHandlerHost";
    actual = lib.looniversity.network.serviceHandlerHost testData.config "step-ca";
    expected = "bigbox";
  }
  {
    name = "network.serviceHandlerHost postgresql";
    actual = lib.looniversity.network.serviceHandlerHost testData.config "postgresql";
    expected = "192.168.1.1";
  }
  {
    name = "network.serviceHandlerFQDN ip address";
    actual = lib.looniversity.network.serviceHandlerFQDN testData.config "postgresql";
    expected = "192.168.1.1";
  }
  {
    name = "network.serviceHandlerFQDN";
    actual = lib.looniversity.network.serviceHandlerFQDN testData.config "step-ca";
    expected = "bigbox.home.arpa";
  }
  {
    skip = "Need to find out how config values are linked to options so that we can test for defaults";
    name = "network.serviceHostName";
    actual = lib.looniversity.network.serviceHostName testData.config "ca";
    expected = "ca";
  }
  {
    name = "network.serviceServiceHandlerName";
    actual = lib.looniversity.network.serviceServiceHandlerName testData.config "ca";
    expected = "step-ca";
  }
]

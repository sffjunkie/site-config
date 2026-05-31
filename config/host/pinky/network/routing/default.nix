{
  config = {
    boot.kernel = {
      sysctl = {
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;

        "net.ipv4.conf.all.arp_filter" = 1;
        "net.ipv4.conf.default.arp_filter" = 1;

        "net.ipv6.conf.all.accept_ra" = 0;
        "net.ipv6.conf.all.autoconf" = 0;
        "net.ipv6.conf.all.use_tempaddr" = 0;

        # On WAN, allow IPv6 autoconfiguration and tempory address use.
        "net.ipv6.conf.wan.accept_ra" = 2;
        "net.ipv6.conf.wan.autoconf" = 1;
      };
    };
  };
}

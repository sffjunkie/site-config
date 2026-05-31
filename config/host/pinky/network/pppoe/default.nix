{
  config = {
    services.pppd = {
      enable = true;
      peers = {
        bt = {
          enable = true;
          autostart = true;

          config = ''
            plugin pppoe.so wan0
            ifname pppoe-bt
            user "homehub@btinternet.com"
            password "BT"

            +ipv6
            ipv6cp-use-ipaddr

            default-asyncmap
            defaultroute
            holdoff 5
            maxfail 0
            mtu 1492
            noaccomp
            noipdefault
            persist
          '';
        };
      };
    };
  };
}

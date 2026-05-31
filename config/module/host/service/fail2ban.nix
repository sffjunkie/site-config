{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.service.fail2ban;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.service.fail2ban = {
    enable = mkEnableOption "fail2ban";
  };

  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;

      jails = {
        DEFAULT = mkDefault ''
          bantime  = 3600
        '';

        sshd-ddos = ''
          filter = sshd-ddos
          maxretry = 2
          action   = iptables[name=ssh, port=ssh, protocol=tcp]
          enabled  = true
        '';

        postfix = ''
          filter   = postfix
          maxretry = 3
          action   = iptables[name=postfix, port=smtp, protocol=tcp]
          enabled  = true
        '';

        postfix-sasl = ''
          filter   = postfix-sasl
          maxretry = 3
          action   = iptables[name=postfix, port=smtp, protocol=tcp]
          enabled  = true
        '';

        postfix-ddos = ''
          filter   = postfix-ddos
          maxretry = 3
          action   = iptables[name=postfix, port=submission, protocol=tcp]
          bantime  = 7200
          enabled  = true
        '';
      };
    };

    environment.etc."fail2ban/filter.d/postfix-ddos.conf".text = ''
      [Definition]
      failregex = lost connection after EHLO from \S+\[<HOST>\]
    '';

    # Limit stack size to reduce memory usage
    systemd.services.fail2ban.serviceConfig.LimitSTACK = 256 * 1024;
  };
}

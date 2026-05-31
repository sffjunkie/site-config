{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.arr.sabnzbd;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.arr.sabnzbd = {
    enable = mkEnableOption "sabnzbd";

    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
    };
  };

  config = mkIf cfg.enable {
    users.groups.media.members = [ "sabnzbd" ];

    services.sabnzbd = {
      enable = true;
      openFirewall = true;
      group = "media";

      configFile = null;
      settings = {
        misc = {
          inherit (cfg) host port;
          host_whitelist = "sabnzbd.${config.looniversity.network.domainName}";
        };
      };
    };
  };
}

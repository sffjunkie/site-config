{ config, lib, ... }:
let
  profiles =
    lib.genAttrs
      [
        "main"
        "iot"
        "not"
        "guest"
      ]

      (
        name: {
          connection = {
            id = "\${${name}_ssid}";
            type = "wifi";
            "interface-name" = lib.mkIf (
              config.looniversity.network.link.wifi.interface != null
            ) config.looniversity.network.link.wifi.interface;
          };

          wifi = {
            mode = "infrastructure";
            ssid = "\${${name}_ssid}";
          };

          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "\${${name}_password}";
          };

          ipv4 = {
            method = "auto";
          };

          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
        }
      );

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.network.link.wifi = {
    enable = mkEnableOption "Wifi ";

    interface = mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    networkmanager = {
      enable = mkEnableOption "NetworkManager";
    };
  };

  config = mkIf config.looniversity.network.link.wifi.enable {
    networking.networkmanager = {
      enable = true;

      ensureProfiles = {
        inherit profiles;
        environmentFiles = [
          config.sops.secrets."wifi/nm_profiles".path
        ];
      };
    };
  };
}

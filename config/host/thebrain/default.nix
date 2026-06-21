{
  lib,
  ...
}:
let
  inherit (lib.looniversity) disabled enabled;
in
{
  imports = [
    ./boot.nix
    ./disko.nix
    ./hardware.nix
    ./networking.nix
    ./user.nix

    ./settings
    ../common
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    looniversity = {
      automation = {
        matter = enabled;
        mosquitto = enabled;
        openthread-border-router = {
          enable = true;
          otbr_device_id = "/dev/serial/by-id/usb-Nabu_Casa_ZBT-2_E072A1FBAD74-if00";
        };
        zigbee2mqtt = enabled;
      };

      db = {
        postgresql = enabled // {
          hostDatabases = {
            thebrain = [ "homeassistant" ];
          };
        };
      };

      media = {
        jellyfin = enabled;
      };

      monitoring = {
        alloy = enabled;
      };

      mount = {
        movies = enabled;
        music = enabled;
        private = enabled;
        tv_shows = enabled;
      };

      network = {
        service.reverse_proxy.caddy.enable = true;
      };

      role = {
        log_server = enabled;
        server = enabled;
        vm_host = enabled;
      };

      service = {
        acme = enabled;
        immich = disabled;
        netbox = enabled;
        nextcloud = disabled;
      };

      shell.zsh = enabled;
    };

    system.stateVersion = "23.05"; # Did you read the comment?
  };
}

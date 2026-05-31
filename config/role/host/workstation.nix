{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.role.workstation;

  inherit (lib) mkEnableOption mkIf;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.role.workstation = {
    enable = mkEnableOption "workstation role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      admin = {
        mqtt = enabled;
        mqttx = enabled;
        mongodb = enabled;
      };

      device = {
        stadia = enabled;
        wacom.enable = false;
        yubikey = enabled;
      };

      role = {
        gui = enabled;
        vm_host = enabled;
      };

      desktop = {
        notification.libnotify = enabled;
      };

      storage = {
        minio-client = enabled;
      };

      media = {
        pipewire = enabled;
      };

      network = {
        service = {
          sshd = enabled;
        };
        link = {
          bluetooth = enabled;

        };
      };

      security = {
        gnome-keyring = enabled;
      };

      service = {
        homepage-dashboard = enabled;
      };

      system = {
        font = enabled;
        nix-index = enabled;
      };

      virtualisation = {
        client = enabled // {
          uri_aliases = [
            {
              name = "thebrain";
              user = "root";
              host = "thebrain";
            }
          ];
        };
      };
    };

    environment.systemPackages = [
      pkgs.deploy-rs
      pkgs.pinentry-gtk2
      pkgs.d-spy
    ];

    # networking.networkmanager = enabled;
    networking.firewall.enable = false;

    services.libinput = enabled;
    services.pcscd = enabled;
  };
}

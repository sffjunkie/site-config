{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib.looniversity) disabled enabled;
in
{
  imports = [
    ./boot.nix
    ./backup.nix
    ./fs.nix
    ./hardware.nix
    ./networking.nix

    ./settings

    ../common

    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-amd

    inputs.nix-index-database.nixosModules.nix-index
  ];

  config = {
    nixpkgs = {
      hostPlatform = lib.mkDefault "x86_64-linux";
    };

    looniversity = {
      admin = {
        mongodb = enabled;
        postgresql = enabled;
      };

      deploy = {
        nixos-anywhere = enabled;
      };

      doc = {
        mystmd = enabled;
      };

      automation = {
        esphome = enabled;
      };

      keyboard.input-remapper = disabled;

      monitoring = {
        alloy = enabled // {
          exposeUI = true;
        };
      };

      mount = {
        backup = enabled;
        movies = enabled;
        music = enabled;
        pictures = enabled;
        private = enabled;
        tv_shows = enabled;
      };

      network = {
        tool = {
          cli = enabled;
        };
        link = {
          wifi = {
            enable = true;
            interface = "wlp3s0";
            networkmanager.enable = true;
          };
        };
      };

      role = {
        container_host = enabled;
        games_machine = enabled;
        podcaster = enabled;
        vm_host = enabled;
        workstation = enabled;
      };

      script.wake = enabled;

      service = {
        forgejo = enabled;
      };

      shell.zsh = enabled;

      storage = {
        udisks2 = enabled;
        zfs.autoscrub = enabled;
      };

      system = {
        rclone = enabled;
        upower = enabled;
      };
    };

    environment = {
      systemPackages = [
        pkgs.teams-for-linux
        pkgs.zoom-us

        inputs.nix-auth.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      localBinInPath = true;
    };

    # systemd.services = {
    #   "rclone@gdrive" = {
    #     wantedBy = [ "default.target" ];
    #   };
    #   "rclone@onedrive" = {
    #     wantedBy = [ "default.target" ];
    #   };
    # };

    system.stateVersion = "23.05"; # Did you read the comment?
  };
}

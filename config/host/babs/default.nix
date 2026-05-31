{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (lib.looniversity) enabled;
in
{
  imports = [
    ./backup.nix
    ./boot.nix
    ./fs.nix
    ./hardware.nix
    ./networking.nix
    ./user.nix

    ./services
    ../common

    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    looniversity = {
      media = {
        jellyfin = enabled;
      };

      network = {
        tool.cli = enabled;
      };

      fs = {
        nfs = {
          exports = [
            {
              path = "/tank0/backup";
              description = "Backup";
            }
            {
              path = "/tank1/music";
              description = "Music";
            }
            {
              path = "/tank1/movies";
              description = "Movies";
            }
            {
              path = "/tank0/pictures";
              description = "Pictures";
            }
            {
              path = "/tank1/private";
              description = "Private";
            }
            {
              path = "/tank1/tv_shows";
              description = "TV Shows";
            }
          ];
          clients = "${toString config.looniversity.network.networkAddress}/${toString config.looniversity.network.prefixLength}";
          opts = [
            "insecure"
            "no_subtree_check"
            "rw"
            "sync"
          ];
        };
        cifs = {
          shares = [
            {
              name = "music";
              path = "/tank1/music";
              description = "Music";
            }
            {
              name = "private";
              path = "/tank1/private";
              description = "Private";
            }
          ];
          opts = {
            "read only" = "yes";
            "browseable" = "yes";
            "guest ok" = "yes";
          };
        };
      };

      monitoring = {
        alloy = enabled;
      };

      storage = {
        minio = {
          enable = true;
          dataDir = [ "/tank0/minio/data" ];
        };
        zfs.autoscrub = enabled;
      };

      theme = {
        stylix = enabled;
      };

      role = {
        arr_stack = enabled;
        server = enabled;
      };
    };

    programs.zsh = enabled;

    system.stateVersion = "23.05"; # Did you read the comment?
  };
}

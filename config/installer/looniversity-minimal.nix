{
  lib,
  pkgs,
  # isoTarget ? "/run/media/sdk/Ventoy/",
  ...
}:
let
  system = "x86_64-linux";
in
{
  config = {
    nixpkgs.hostPlatform = lib.mkDefault system;

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    boot.loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    swapDevices = lib.mkImageMediaOverride [ ];
    fileSystems = {
      "/" = lib.mkImageMediaOverride {
        fsType = "tmpfs";
        options = [ "mode=0755" ];
      };
    };

    looniversity = {
      network = {
        link = {
          wifi = {
            enable = true;
            networkmanager.enable = true;
          };
        };
      };
    };

    environment.systemPackages = [
      pkgs.age
      pkgs.gitMinimal
      pkgs.gnumake
      pkgs.jq
      pkgs.just
      pkgs.sops
      pkgs.ssh-to-age
      pkgs.yq
    ];

    services.openssh.enable = true;

    users.users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFugnsOEmySWbh2hIrAjroWAO+PB4RznGnt+oDuERsU"
      ];
    };

    system.stateVersion = "23.05"; # Did you read the comment?
  };
}

{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib.looniversity) enabled;
in
{
  imports = [
    ./boot.nix
    ./fs.nix
    ./hardware.nix
    ./networking.nix

    ../common

    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
  ];

  config = {
    # Added for Obsidian
    nixpkgs = {
      hostPlatform = lib.mkDefault "x86_64-linux";
    };

    looniversity = {
      role = {
        laptop = enabled;
        vm_host = enabled;
      };

      shell.zsh = enabled;

      storage.udisks2 = enabled;

      theme = {
        nord = enabled;
        papirus = enabled;
        stylix = enabled;
      };
    };

    environment = {
      systemPackages = [
        pkgs.teams-for-linux
        pkgs.zoom-us
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };

      localBinInPath = true;
    };

    system.stateVersion = "23.05";
  };
}

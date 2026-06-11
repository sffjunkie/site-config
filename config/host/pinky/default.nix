{
  config,
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
    ./network

    ../common
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    looniversity = {
      monitoring = {
        alloy = enabled // {
          node = config.networking.hostName;
        };
      };

      network = {
        firewall = disabled;
        service = {
          dhcp = enabled;
          dns-a = enabled;
          dns-m = enabled;
          dns-r = enabled;
          sshd = enabled;
          wireguard = disabled;
        };
        tool.cli = enabled;
      };

      service.lldap = disabled;

      shell.zsh = enabled;
    };

    environment = {
      localBinInPath = true;
    };

    system.stateVersion = "23.05";
  };
}

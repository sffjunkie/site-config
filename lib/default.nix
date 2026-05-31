{
  lib,
  ns,
  ...
}:
final: prev: {
  "${ns}" = {
    enabled = {
      enable = true;
    };
    disabled = {
      enable = false;
    };

    ipv4 = import ./ipv4.nix { inherit lib ns; };
    network = import ./network.nix { inherit lib ns; };
    tool = import ./tool.nix { inherit lib ns; };
  };
  nut = import ./nut.nix { inherit lib ns; };
}

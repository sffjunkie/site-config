{ pkgs, ... }:
let
  tmpDir = "/var/tmp/nixos-rebuild";
  nixosScripts = pkgs.callPackage ./scripts { inherit tmpDir; };
in
pkgs.mkShell {
  buildInputs = [
    pkgs.jq
    pkgs.nh
    pkgs.nix-info
    pkgs.nix-output-monitor
    pkgs.nix-template
    pkgs.nix-tree
    pkgs.nix-update
    pkgs.nixfmt
    pkgs.nixpkgs-review
    pkgs.nvd
    pkgs.reuse
    pkgs.treefmt
  ]
  ++ nixosScripts;
  env = {
    NIX_DEVSHELL_PROJECT = "siteconfig";
  };
}

{
  pkgs,
  tmpDir ? "/var/tmp/nixos-rebuild",
  ...
}:
let
  nixosScriptDeploy = pkgs.callPackage ./deploy.nix { };
  nixosScriptGenerations = pkgs.callPackage ./generations.nix { };
  nixosScriptInstaller = pkgs.callPackage ./installer.nix { };
  nixosScriptRebuild = pkgs.callPackage ./rebuild.nix { inherit tmpDir; };
  nixosScriptUnittest = pkgs.callPackage ./unittest.nix { };
  nixosScriptVm = pkgs.callPackage ./vm.nix { };
in
[
  nixosScriptDeploy
  nixosScriptGenerations
  nixosScriptInstaller
  nixosScriptRebuild
  nixosScriptUnittest
  nixosScriptVm
]

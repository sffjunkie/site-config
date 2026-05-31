{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.security.sops;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.security.sops = {
    enable = mkEnableOption "sops";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sops
      pkgs.ssh-to-age
    ];

    sops.age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}

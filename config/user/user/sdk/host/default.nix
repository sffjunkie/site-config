{
  config,
  pkgs,
  ...
}:
let
  username = "sdk";
in
{
  imports = [
    ./backup/local.nix
    ./backup/nas.nix
    ./settings

    ../../common/host
  ];

  config = {
    users.users.${username} = {
      isNormalUser = true;
      uid = 1001;
      description = "me";
      extraGroups = [
        "dialout"
        "docker"
        "libvirtd"
        "networkmanager"
        "podman"
        "wheel"
      ];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFugnsOEmySWbh2hIrAjroWAO+PB4RznGnt+oDuERsU ${username}"
        ];
      };
      hashedPasswordFile = config.sops.secrets."sdk/password_hash".path;
    };

    users.groups.media.members = [ username ];

    services.openssh.settings.AllowUsers = [ username ];
  };
}

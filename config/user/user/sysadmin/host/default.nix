{
  config,
  pkgs,
  ...
}:
let
  username = "sysadmin";
in
{
  config = {
    users.users.${username} = {
      isNormalUser = true;
      uid = 1000;
      description = "System Administrator";
      extraGroups = [
        "docker"
        "networkmanager"
        "podman"
        "wheel"
      ];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO17K8Ei9367OcAQtB/u/LXb9elGRGJh0p4S9n6DrBy9 ${username}"
        ];
      };
      hashedPasswordFile = config.sops.secrets."sdk/password_hash".path;
    };

    services.openssh.settings.AllowUsers = [ username ];
  };
}

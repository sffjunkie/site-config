{ lib, ... }:
let
  ageKeyFile = "/home/sysadmin/secrets/sops/age/keys.txt";

  inherit (lib.looniversity) enabled;
in
{
  config = {
    programs.home-manager = enabled;

    home = {
      username = "sysadmin";
      homeDirectory = "/home/sysadmin";
      stateVersion = "23.05";
      sessionVariables = {
        SOPS_AGE_KEY_FILE = ageKeyFile;
      };
    };

    looniversity = {
      cli = {
        bat = enabled;
        zoxide = enabled;
      };
      shell = {
        zsh = enabled;
      };
    };

    sops = {
      age.keyFile = ageKeyFile;
    };
  };
}

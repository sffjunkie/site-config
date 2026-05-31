{
  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          setEnv = {
            TERM = "xterm-256color";
          };
        };
        "pinky" = {
          hostname = "10.44.0.1";
          user = "sdk";
          identityFile = [ "~/.ssh/id_ed25519" ];
        };
        "pinky2" = {
          hostname = "10.44.1.4";
          user = "sysadmin";
          identityFile = [ "~/.ssh/id_ed25519.sysadmin" ];
        };
        "thebrain" = {
          hostname = "10.44.1.1";
          user = "sdk";
          identityFile = [ "~/.ssh/id_ed25519" ];
        };
        "thebrain2" = {
          hostname = "10.44.0.2";
          user = "sysadmin";
          identityFile = [ "~/.ssh/id_ed25519.sysadmin" ];
        };
        "babs" = {
          hostname = "10.44.0.3";
          user = "sysadmin";
          identityFile = [ "~/.ssh/id_ed25519.sysadmin" ];
        };
        "hassos" = {
          hostname = "10.44.1.2";
          user = "root";
          identityFile = [ "~/.ssh/id_ed25519" ];
        };
        "unifios" = {
          hostname = "10.44.1.3";
          identityFile = [ "~/.ssh/id_ed25519" ];
        };
      };
    };
  };
}

{
  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "Host *" = {
          SetEnv = {
            TERM = "xterm-256color";
          };
        };
        "Host pinky" = {
          hostname = "10.44.0.1";
          user = "sdk";
          identityFile = [ "~/.ssh/id_ed25519" ];
        };
        "Host pinky2" = {
          hostname = "10.44.1.4";
          user = "sysadmin";
          identityFile = [ "~/.ssh/id_ed25519.sysadmin" ];
        };
        "Host thebrain" = {
          hostname = "10.44.1.1";
          user = "sdk";
          identityFile = [ "~/.ssh/id_ed25519" ];
        };
        "Host thebrain2" = {
          hostname = "10.44.0.2";
          user = "sysadmin";
          identityFile = [ "~/.ssh/id_ed25519.sysadmin" ];
        };
        "Host babs" = {
          hostname = "10.44.0.3";
          user = "sysadmin";
          identityFile = [ "~/.ssh/id_ed25519.sysadmin" ];
        };
        "Host hassos" = {
          hostname = "10.44.1.2";
          user = "root";
          identityFile = [ "~/.ssh/id_ed25519" ];
        };
        "Host unifios" = {
          hostname = "10.44.1.3";
          identityFile = [ "~/.ssh/id_ed25519" ];
        };
      };
    };
  };
}

{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./environment.nix
    ./l10n.nix
    ./modules.nix
    ./nix.nix
    ./packages.nix
    ./workaround.nix
  ];

  config = {
    sops = {
      defaultSopsFormat = "yaml";
      age.sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      # defaultSopsFile = config.site.paths.secrets.default;
    };

    services.dbus.implementation = "broker";
    services.getty.greetingLine = "Welcome to the Looniversity";

    environment.shellAliases = {
      df = "df -h";
      dfs = "df -ha | (read -r; printf \"%s\\n\" \"\$REPLY\"; sort)";
      dmesg = "dmesg -T";
      free = "free -h";
      ldot = "ll ~/.config";
      lf = "declare -f | grep ' ()' | awk '{print $1}'";
      nano = "nano -l --guidestripe=72";
      nb = "nix build";
      nd = "nix develop --command \${SHELL}";
      nfc = "nix flake check";
      nfm = "nix flake metadata";
      nfs = "nix flake show";
      nfu = "nix flake update";
      hgrep = "history | grep";
      ping = "ping -c 4";
      ":q" = "exit";
    };

    environment.interactiveShellInit = ''
      ffd() { loc=$1; shift; find $loc -type f "$@"; }
      fft() { loc=$1; shift; find $loc -type f -printf "%CY-%Cm-%Cd %CH:%CM %p\n" "$@"; }
      ffts() { loc=$1; shift; find $loc -type f -printf "%CY-%Cm-%Cd %CH:%CM %p\n" "$@" | sort; }
      fdd() { loc=$1; shift; find $loc -type d "$@"; }
      fdt() { loc=$1; shift; find $loc -type d -printf "%CY-%Cm-%Cd %CH:%CM %p\n" "$@"; }
      fdts() { loc=$1; shift; find $loc -type d -printf "%CY-%Cm-%Cd %CH:%CM %p\n" "$@" | sort; }

      fjq() { cat "$1" | ${pkgs.jq}/bin/jq .; }

      # Pull all repos in a directory
      gpa() {
        [ -z "$1" ] && loc="." || loc=$1
        find $loc -mindepth 1 -maxdepth 1 -type d -exec git -C {} pull \;
      }

      # git merge into main
      gmim() {
        repo=''${1:-develop}
        git switch main
        git merge $repo --ff-only
        git switch $repo
      }

      npr() {
        [ -z "$1" ] && flake="(builtins.getFlake flake:nixpkgs)" || flake=$1
        nix repl --extra-experimental-features 'flakes' --expr "import ''${flake} {}"
      }

      nps() {
        args=( "$@" )
        IFS=","
        echo "Starting a shell with packages: $args[*]"
        [ "$#" -gt 1 ] && shellarg="nixpkgs#{$args[*]}" || shellarg="nixpkgs#$1"
        eval nix shell "$shellarg"
      }
    '';
  };
}

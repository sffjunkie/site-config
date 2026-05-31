{
  pkgs,
  tmpDir ? "/var/tmp/nixos-rebuild",
  ...
}:
let
  script = pkgs.writeShellScriptBin "nor" ''
    TMPDIR=${tmpDir}

    VALID_ARGS=$(getopt -o sv --long show-trace,verbose -- "''$@")
    if [[ $? -ne 0 ]]; then
        exit 1;
    fi

    extra_args=()
    extra_info=""
    eval set -- "$VALID_ARGS"
    while [ : ]; do
      case "$1" in
        -v | --verbose)
            extra_args+=("--verbose")
            extra_info+=" + verbose"
            shift
            ;;
        -s | --show-trace)
            extra_args+=("--show-trace")
            extra_info+=" + trace"
            shift
            ;;
        --) shift;
            break
            ;;
      esac
    done

    if [ -z "$2" ]; then
      target="$(hostname)"
    else
      target="$2"
    fi

    COLUMNS=$(tput cols)

    header() {
        ${pkgs.figlet}/bin/figlet \
          -d "${pkgs.figlet}/share/figlet" \
          -f doom \
          -w "''${COLUMNS}" \
          "$target  :  $1''${extra_info}"
    }

    case "$1" in
      build)
        header "$1"
        nixos-rebuild build --flake ".#''${target}" \
          --log-format internal-json "''${extra_args[@]}" |& \
          ${pkgs.nix-output-monitor}/bin/nom --json
        ;;

      dry-build)
        header "$1"
        nixos-rebuild dry-build --flake ".#''${target}" \
          --log-format internal-json "''${extra_args[@]}" |& \
          ${pkgs.nix-output-monitor}/bin/nom --json
        ;;

      boot)
        sudo echo -n
        header "$1"
        sudo nixos-rebuild boot --flake ".#''${target}" \
          --log-format internal-json "''${extra_args[@]}" |& \
          ${pkgs.nix-output-monitor}/bin/nom --json
        ;;

      switch)
        sudo echo -n
        header "$1"
        sudo nixos-rebuild switch --flake ".#''${target}" \
          --log-format internal-json "''${extra_args[@]}" |& \
          ${pkgs.nix-output-monitor}/bin/nom --json
        ;;

      *)
        [ $# -eq 0 ] && echo -n "No mode specified. "
        echo "Mode must be one of 'build', 'dry-build', 'boot' or 'switch'"
        exit 1
        ;;
    esac
  '';
in
script

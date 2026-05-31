{
  pkgs,
  ...
}:
let
  script = pkgs.writeShellScriptBin "rofi-clip" ''
    help() {
      echo "rofi-clip - rofi clipboard management"
      echo
      echo "Usage:  rofi-clip [options] <cmd>"
      echo "  copy      copy an item from list of clips"
      echo "  delete    delete an item from list of clips"
      echo "  -h, --help      show this help message"
    }

    VALID_ARGS=$(getopt -o h --long help -- "''$@")
    if [[ $? -ne 0 ]] || [[ $# -eq 0 ]]; then
      help
      exit 0;
    fi

    rofi_clip_select() {
      cliphist list | \
        rofi -dmenu -theme-str '@import "looniversity"' -p "clipboard - select" | \
        cliphist decode | \
        wl-copy
    }

    rofi_clip_delete() {
      cliphist list | \
        rofi -dmenu -theme-str '@import "looniversity"' -p "clipboard - delete" | \
        cliphist delete
    }

    output=""
    copy=0
    delete=0
    eval set -- "$VALID_ARGS"
    while [ : ]; do
      case "$1" in
        -h | --help)
          help
          exit 0
          ;;
        copy)
          copy=1
          break
          ;;
        delete)
          delete=1
          break
          ;;
        --)
          break
          ;;
      esac
    done

    if [ $delete -eq 1 ]; then
      rofi_clip_delete
    else
      rofi_clip_select
    fi
  '';
in
script

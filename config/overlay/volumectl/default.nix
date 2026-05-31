# TODO: determine output to control
{
  lib,
  pkgs,
  ...
}:
let
  pulsemixer = lib.getExe pkgs.pulsemixer;
  volume_controller = pulsemixer;
  volume_app_tui = pulsemixer;
  volume_app_gui = lib.getExe pkgs.pavucontrol;
  volume_step = 10;
in
pkgs.writeShellScriptBin "volumectl" ''
  case "$1" in
    app)
      if [ -t 0 ] ; then
          ${volume_app_tui}
      else
          ${volume_app_gui}
      fi
      ;;
    up)
      ${volume_controller} --change-volume +"${toString volume_step}"
      ;;
    down)
      ${volume_controller} --change-volume -"${toString volume_step}"
      ;;
    toggle)
      ${volume_controller} --toggle-mute
      ;;
    mute)
      ${volume_controller} --mute
      ;;
    *)
      ${volume_controller} --get-volume
      ;;
  esac

  exit 0
''

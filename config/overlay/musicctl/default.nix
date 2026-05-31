{
  lib,
  pkgs,
  ...
}:
let
  notify_send = lib.getExe pkgs.libnotify;
  mpc = lib.getExe pkgs.mpc;
  ncmpcpp = lib.getExe pkgs.ncmpcpp;
  playerctl = "${lib.getExe pkgs.playerctl} -p mpd";
  pulsemixer = lib.getExe pkgs.pulsemixer;
in
pkgs.writeShellScriptBin "musicctl" ''
  case "$1" in
    app)
      if [ -t 0 ] ; then
          ${ncmpcpp}
      else
          ${lib.getExe pkgs.ghostty} -e ${ncmpcpp}
      fi
      ;;
    next)
      ${playerctl} next
      ;;
    prev)
      ${playerctl} previous
      ;;
    toggle)
      ${playerctl} play-pause
      ${notify_send} --app-name=music-notify --hint=int:transient:1 -t 2000 "MPD" "$(${mpc} current)\\n$(${mpc} | sed -n 2p)"
      ;;
    stop)
      ${playerctl} stop
      ${notify_send} --app-name=music-notify --hint=int:transient:1 -t 2000 "MPD" "stopped"
      ;;
    mixer)
        ${pulsemixer}
        ;;
    *)
        ${playerctl} metadata
        ;;
  esac

  exit 0
''

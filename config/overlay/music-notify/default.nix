{
  lib,
  pkgs,
  musicMount ? "/mnt/music",
  iconSize ? 256,
  ...
}:
let
  ffmpeg = lib.getExe pkgs.ffmpeg;
  mpc = lib.getExe pkgs.mpc;
  notify-send = lib.getExe pkgs.libnotify;
in
pkgs.writeShellScriptBin "music-notify" ''
  music_dir="/mnt/music"
  filename="$(${mpc} --format "${musicMount}"/%file% current)"

  previewdir="/tmp/coverart_previews"
  mkdir -p $previewdir
  previewname="$previewdir/$(${mpc} --format %album% current | base64).png"
  [ -e "$previewname" ] || ${ffmpeg} -y -i "$filename" -an -vf scale=${toString iconSize}:${toString iconSize} "$previewname" > /dev/null 2>&1

  ${notify-send} --app-name=music-notify \
    --replace-id=27072 \
    --expire-time=4000 \
    --icon="$previewname" \
    "Now Playing" "$(${mpc} --format='󰝚 %title%\n󰠃 %artist%\n󰀥 %album%' current)"
''

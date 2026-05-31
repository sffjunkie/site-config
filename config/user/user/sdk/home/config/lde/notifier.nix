{
  config,
  formatter,
  lib,
  pkgs,
  ...
}:
let
  general_notifier_pkg = lib.attrByPath [
    config.looniversity.user.notifier.general
  ] pkgs.libnotify pkgs;

  music_notifier_pkg = lib.attrByPath [
    config.looniversity.user.notifier.music_track_change
  ] pkgs.music-notify pkgs;
in
formatter.generate "desktop-notifier" {
  notifier = {
    general = lib.getExe general_notifier_pkg;
    music_track_change = lib.getExe music_notifier_pkg;
  };
}

{
  config,
  formatter,
  lib,
  pkgs,
  ...
}:
let
  audio_controller_pkg = lib.attrByPath [
    config.looniversity.user.controller.audio
  ] pkgs.pavucontrol pkgs;

  music_controller_pkg = lib.attrByPath [
    config.looniversity.user.controller.music
  ] pkgs.musicctl pkgs;

  volume_controller_pkg = lib.attrByPath [
    config.looniversity.user.controller.volume
  ] pkgs.volumectl pkgs;
in
formatter.generate "desktop-controller" {
  controller = {
    audio.app = lib.getExe audio_controller_pkg;
    music.app = lib.getExe music_controller_pkg;
    volume.app = lib.getExe volume_controller_pkg;
  };
}

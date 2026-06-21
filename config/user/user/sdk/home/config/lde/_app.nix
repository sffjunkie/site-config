{
  config,
  formatter,
  lib,
  pkgs,
  ...
}:
let
  brain_pkg = lib.attrByPath [
    config.looniversity.user.apps.brain
  ] pkgs.obsidian pkgs;

  browser_pkg = lib.attrByPath [
    config.looniversity.user.apps.browser
  ] pkgs.firefox pkgs;

  code_editor_pkg = lib.attrByPath [
    config.looniversity.user.apps.code_editor
  ] pkgs.vscode pkgs;

  editor_pkg = lib.attrByPath [
    config.looniversity.user.apps.editor
  ] pkgs.micro pkgs;

  file_manager_pkg = lib.attrByPath [
    config.looniversity.user.apps.file_manager
  ] pkgs.ranger pkgs;

  launcher_pkg = lib.attrByPath [
    config.looniversity.user.apps.launcher
  ] pkgs.rofi-app-launcher pkgs;

  music_player_pkg = lib.attrByPath [
    config.looniversity.user.apps.music_player
  ] pkgs.ncmpcpp pkgs;

  pager_pkg = lib.attrByPath [
    config.looniversity.user.apps.pager
  ] pkgs.bat pkgs;

  screenshot_pkg = lib.attrByPath [
    config.looniversity.user.apps.screenshot
  ] pkgs.sshot pkgs;

  terminal_pkg = lib.attrByPath [
    config.looniversity.user.apps.terminal
  ] pkgs.ghostty pkgs;
in
formatter.generate "desktop-app" {
  app = {
    brain = lib.getExe brain_pkg;
    browser = lib.getExe browser_pkg;
    clipboard = lib.getExe pkgs.rofi-clip;
    code_editor = lib.getExe code_editor_pkg;
    editor = lib.getExe editor_pkg;
    file_manager = lib.getExe file_manager_pkg;
    launcher = lib.getExe launcher_pkg;
    music_player = lib.getExe music_player_pkg;
    pager = lib.getExe pager_pkg;
    screenshot = lib.getExe screenshot_pkg;
    terminal = lib.getExe terminal_pkg;
  };
}

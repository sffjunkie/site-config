{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.looniversity.user.apps = {
    brain = mkOption {
      description = "Application to use as your second brain";
      type = types.str;
      default = "";
    };

    browser = mkOption {
      description = "Application to use as the web browser";
      type = types.str;
      default = "";
    };

    clipboard = mkOption {
      description = "Application to use as the clipboard manager";
      type = types.str;
      default = "";
    };

    code_editor = mkOption {
      description = "Application to use as the code editor";
      type = types.str;
      default = "";
    };

    editor = mkOption {
      description = "Application to use as the editor";
      type = types.str;
      default = "";
    };

    file_manager = mkOption {
      description = "Application to use as the file manager";
      type = types.str;
      default = "";
    };

    launcher = mkOption {
      description = "Application to use as the app launcher";
      type = types.str;
      default = "";
    };

    music_player = mkOption {
      description = "Application to use as the file manager";
      type = types.str;
      default = "";
    };

    pager = mkOption {
      description = "Application to use as the cli pager";
      type = types.str;
      default = "";
    };

    screenshot = mkOption {
      description = "Application to use to take screenshots";
      type = types.str;
      default = "";
    };

    terminal = mkOption {
      description = "Application to use as the terminal";
      type = types.str;
      default = "";
    };
  };
}

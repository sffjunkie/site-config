{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.looniversity.user = {
    notifier = {
      general = mkOption {
        description = "Application to display notifications";
        type = types.str;
        default = "";
      };

      music_track_change = mkOption {
        description = "Application to display a notification on music player track change";
        type = types.str;
        default = "";
      };
    };
  };
}

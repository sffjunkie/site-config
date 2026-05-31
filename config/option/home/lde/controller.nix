{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.looniversity.user = {
    controller = {
      audio = mkOption {
        description = "Application to use as the audio controller";
        type = types.str;
        default = "";
      };

      music = mkOption {
        description = "Command to control music";
        type = types.str;
        default = "";
      };

      volume = mkOption {
        description = "Command to control volume";
        type = types.str;
        default = "";
      };
    };
  };
}

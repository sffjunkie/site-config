{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.looniversity.user = {
    menu = {
      system = mkOption {
        description = "Command to show the system menu";
        type = types.str;
        default = "";
      };

      user = mkOption {
        description = "Command to show the user menu";
        type = types.str;
        default = "";
      };
    };
  };
}

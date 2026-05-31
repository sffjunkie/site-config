{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.games_machine;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (lib.looniversity) disabled enabled;
in
{
  options.looniversity.role.games_machine = {
    enable = mkEnableOption "games machine role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      role.gui = enabled;

      game = {
        steam = enabled;
        lutris = enabled;

        retroarch = enabled;
      };

      media = {
        pipewire = enabled;
      };

      mount = {
        roms = disabled;
      };
    };

    hardware = {
      xone = enabled;
    };

    environment.sessionVariables = {
      SDL_VIDEODRIVER = "wayland,x11,windows";
    };
  };
}

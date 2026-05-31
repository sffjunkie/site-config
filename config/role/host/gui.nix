{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.gui;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.role.gui = {
    enable = mkEnableOption "gui role";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
    };

    looniversity = {
      desktop = {
        environment = {
          gnome.enable = false;
          lde = enabled;
        };
      };
    };
  };
}

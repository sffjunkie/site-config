{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.desktop.display_manager.greetd;

  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.desktop.display_manager.greetd = {
    enable = mkEnableOption "greetd display manager";
  };

  config = mkIf cfg.enable {
    services.greetd = enabled;

    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
    };

    systemd.services.greetd.serviceConfig = {
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}

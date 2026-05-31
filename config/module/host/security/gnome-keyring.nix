{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.security.gnome-keyring;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.security.gnome-keyring = {
    enable = mkEnableOption "gnome-keyring";
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring = enabled;
  };
}

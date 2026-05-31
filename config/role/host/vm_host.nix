{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.vm_host;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.role.vm_host = {
    enable = mkEnableOption "vm host role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      script.dnsmasq = enabled;

      virtualisation = {
        server = enabled;
      };

      mount.iso = enabled;
    };
  };
}

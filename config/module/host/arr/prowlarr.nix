{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.arr.prowlarr;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.arr.prowlarr = {
    enable = mkEnableOption "prowlarr";
  };

  config = mkIf cfg.enable {
    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };
  };
}

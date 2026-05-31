{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.arr.bazarr;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.arr.bazarr = {
    enable = mkEnableOption "bazarr";
  };

  config = mkIf cfg.enable {
    users.groups.media.members = [ "bazarr" ];

    services.bazarr = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
  };
}

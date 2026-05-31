{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.storage.udisks2;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (lib.looniversity) enabled;
in
{
  options = {
    looniversity.storage.udisks2 = {
      enable = mkEnableOption "udisks2";
    };
  };

  config = mkIf cfg.enable {
    services.udisks2 = enabled;
  };
}

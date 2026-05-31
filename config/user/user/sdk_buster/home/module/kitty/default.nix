{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.kitty;
  inherit (lib) mkIf mkForce;
in
{
  config = mkIf cfg.enable {
    programs.kitty.font.size = mkForce 9;
  };
}

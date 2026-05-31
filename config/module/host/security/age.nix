{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.security.age;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.security.age = {
    enable = mkEnableOption "age";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.age
    ];
  };
}

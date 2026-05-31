{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.shell.zmx;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.looniversity.shell.zmx = {
    enable = mkEnableOption "zmx";
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.zmx.packages.${pkgs.stdenv.hostPlatform.system}.zmx
    ];
  };
}

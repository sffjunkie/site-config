{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.nixvim;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.editor.nixvim = {
    enable = mkEnableOption "nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;

      extraPackages = [
        pkgs.vimPlugins.nvim-web-devicons
      ];
    };
  };
}

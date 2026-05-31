{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.terminal.kitty;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.terminal.kitty = {
    enable = mkEnableOption "kitty";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      extraConfig = ''
        enable_audio_bell no
      '';
    };
  };
}

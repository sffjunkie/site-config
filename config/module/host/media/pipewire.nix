{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.media.pipewire;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.media.pipewire = {
    enable = mkEnableOption "pipewire";
  };

  config = mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit = enabled;
    services.pipewire = {
      enable = true;
      alsa = enabled // {
        support32Bit = true;
      };
      jack = enabled;
      pulse = enabled;
    };
  };
}

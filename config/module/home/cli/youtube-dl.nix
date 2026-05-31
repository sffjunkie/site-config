{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.cli.youtubeDl;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.youtubeDl = {
    enable = mkEnableOption "youtube-dl";
  };

  config = mkIf cfg.enable {
    programs.yt-dlp = {
      enable = true;
      settings = {
        paths = "home:~/videos/youtube/";
      };
    };
  };
}

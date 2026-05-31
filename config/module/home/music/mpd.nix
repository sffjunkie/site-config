{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.music.mpd;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  mpdFifoPath = "/run/user/${toString cfg.uid}/mpd.fifo";
in
{
  options.looniversity.music.mpd = {
    enable = mkEnableOption "music mpd";

    uid = mkOption {
      type = types.int;
      default = 1000;
      description = "User id";
    };

    host = mkOption {
      type = types.str;
      default = "localhost";
    };

    port = mkOption {
      type = types.port;
      default = 6600;
    };

    visualizerFifoPath = mkOption {
      type = types.str;
      default = mpdFifoPath;
    };

    visualizerFifoName = mkOption {
      type = types.str;
      default = "MPD visualizer FIFO";
    };

    outputType = mkOption {
      type = types.str;
      default = "pipewire";
    };

    outputName = mkOption {
      type = types.str;
      default = "PipeWire";
    };
  };

  config = mkIf cfg.enable {
    services.mpdris2 = {
      enable = true;
    };

    services.mpd = {
      enable = true;
      musicDirectory = "/mnt/music";
      network = {
        inherit (config.looniversity.music.mpd) port;
        listenAddress = config.looniversity.music.mpd.host;
      };
      extraConfig = ''
        audio_output {
          type            "${config.looniversity.music.mpd.outputType}"
          name            "${config.looniversity.music.mpd.outputName}"
        }

        audio_output {
          type    "fifo"
          name    "${config.looniversity.music.mpd.visualizerFifoName}"
          format  "44100:16:2"
          path    "${config.looniversity.music.mpd.visualizerFifoPath}"
        }
      '';
    };
  };
}

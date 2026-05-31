{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.looniversity.cli.cava;
in
{
  options.looniversity.cli.cava = {
    inherit (options.programs.cava) enable settings;
  };

  config = lib.mkIf cfg.enable {
    programs.cava = {
      enable = true;
      inherit (config.looniversity.cli.cava) settings;
    };
  };
}

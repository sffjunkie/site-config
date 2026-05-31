{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.gui.qutebrowser;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.gui.qutebrowser = {
    enable = mkEnableOption "qutebrowser";
  };

  config = mkIf (cfg.enable || config.looniversity.user.apps.browser == "qutebrowser") {
    stylix.targets.qutebrowser = enabled;

    programs.qutebrowser = {
      enable = true;

      searchEngines = {
        g = "https://www.google.co.uk/search?hl=en&q={}";
        nw = "https://nixos.wiki/index.php?search={}";
        wp = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      };

      settings = {
        fonts = {
          default_family = lib.mkDefault "JetBrainsMono Nerd Font Mono";
          default_size = lib.mkDefault "16pt";
        };
        tabs = {
          position = "left";
          show = "multiple";
        };
        content.tls.certificate_errors = "ask-block-thirdparty";
      };
    };

    programs.ranger.rifle = [
      {
        condition = "ext x?html?, has qutebrowser, X, flag f";
        command = ''qutebrowser -- "$@"'';
      }
    ];
  };
}

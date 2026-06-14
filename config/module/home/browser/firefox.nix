{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.gui.firefox;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.firefox = {
    enable = mkEnableOption "firefox";
  };

  config = mkIf (cfg.enable || config.looniversity.user.apps.browser == "firefox") {
    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      profiles = {
        default = {
          extensions.force = true;
          settings = {
            "browser.ai.control.default" = "blocked";
            "browser.ai.control.linkPreviewKeyPoints" = "blocked";
            "browser.ai.control.pdfjsAltText" = "blocked";
            "browser.ai.control.sidebarChatbot" = "blocked";
            "browser.ai.control.smartTabGroups" = "blocked";
            "browser.ai.control.translations" = "blocked";
          };
        };
      };
    };
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.user.apps;

  inherit (lib) mkIf;
in
{
  config = {
    sops = {
      defaultSopsFormat = "yaml";
      defaultSopsFile = config.site.paths.secrets.default;
    };

    programs.bash.enable = true;

    home.sessionVariables = {
      BROWSER = cfg.browser;
      CODE_EDITOR = cfg.code_editor;
      EDITOR = cfg.editor;
      FILEMANAGER = cfg.file_manager;
      PAGER = cfg.pager;
      TERMINAL = cfg.terminal;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = mkIf (cfg.browser != "") "${cfg.browser}.desktop";
        "x-scheme-handler/https" = mkIf (cfg.browser != "") "${cfg.browser}.desktop";
        "x-scheme-handler/about" = mkIf (cfg.browser != "") "${cfg.browser}.desktop";
        "x-scheme-handler/unknown" = mkIf (cfg.browser != "") "${cfg.browser}.desktop";
      };
    };
  };
}

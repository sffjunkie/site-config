{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.ranger;

  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.cli.ranger = {
    enable = mkEnableOption "ranger";

    settings = mkOption {
      type = types.attrsOf (
        types.oneOf [
          types.str
          types.int
          types.bool
        ]
      );
      default = { };
    };
  };

  config = mkIf cfg.enable {
    programs.ranger = {
      enable = true;

      extraPackages = [
        pkgs.python3.pkgs.pillow
      ];

      settings = {
        draw_borders = true;
        preview_images = true;
        preview_images_method = "kitty";
        show_hidden = true;
        vcs_aware = true;
        vcs_backend_git = "local";
      };

      rifle = [
        {
          condition = "mime ^text,  label editor";
          command = ''''${VISUAL:-$EDITOR} -- "$@"'';
        }
        {
          condition = "mime ^text,  label pager";
          command = ''''$PAGER -- "$@"'';
        }
        {
          condition = "!mime ^text, label editor, ext xml|json|csv|tex|py|pl|rb|rs|js|sh|php|dart|nim|conf|service|timer";
          command = ''''${VISUAL:-$EDITOR} -- "$@"'';
        }
        {
          condition = "!mime ^text, label pager,  ext xml|json|csv|tex|py|pl|rb|rs|js|sh|php|dart|nim|conf|service|timer";
          command = ''''$PAGER -- "$@"'';
        }
        {
          condition = "ext py, has python3";
          command = ''python3 -- "$1"'';
        }
        # {
        #   condition = "";
        #   command = '''';
        # }
      ];
    };

    home.sessionVariables = mkDefault {
      FILEMANAGER = "ranger";
    };
  };
}

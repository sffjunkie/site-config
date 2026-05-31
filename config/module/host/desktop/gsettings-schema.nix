{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.desktop.gsettings-schema;

  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.desktop.gsettings-schema = {
    enable = mkEnableOption "gsettings-schema";

    schemaPackages = mkOption {
      default = [ ];
      type = types.listOf types.package;
      example = literalExpression "[ pkgs.gsettings-desktop-schemas ]";
    };
  };

  config = mkIf cfg.enable {
    looniversity.desktop.gsettings-schema.schemaPackages = [
      pkgs.gsettings-desktop-schemas
    ];

    environment.extraInit = ''
      ${lib.concatMapStrings (p: ''
        if [ -d "${p}/share/gsettings-schemas/${p.name}" ]; then
          export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${p}/share/gsettings-schemas/${p.name}
        fi
      '') cfg.schemaPackages}
    '';
  };
}

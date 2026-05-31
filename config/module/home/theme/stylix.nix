{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.theme.stylix;

  targetsAttrtrset = lib.listToAttrs (
    map (name: {
      inherit name;
      value = {
        enable = false;
      };
    }) config.looniversity.theme.stylix.disabledTargets
  );

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.theme.stylix = {
    enable = mkEnableOption "stylix";

    disabledTargets = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      iconTheme = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
      };
      polarity = "dark";
      targets = targetsAttrtrset;
    };
  };
}

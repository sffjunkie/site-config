{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.wayland.clipboard.cliphist;
  cliphistCfg = config.services.cliphist;

  textPaste = [
    (lib.getExe' cliphistCfg.clipboardPackage "wl-paste")
    "--primary"
  ];

  imagePaste = textPaste ++ [
    "--type"
    "image"
  ];

  textPasteCmd = lib.concatStringsSep " " textPaste;
  imagePasteCmd = lib.concatStringsSep " " imagePaste;

  watchCmd = lib.concatStringsSep " " [
    "--watch"
    (lib.getExe cliphistCfg.package)
    (lib.concatStringsSep " " cliphistCfg.extraOptions)
    "store"
  ];

  inherit (lib)
    mkForce
    mkEnableOption
    mkIf
    ;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.wayland.clipboard.cliphist = {
    enable = mkEnableOption "cliphist";
  };

  config = mkIf cfg.enable {
    services.cliphist = {
      enable = true;
      systemdTargets = [ "lde-session.target" ];
    };

    systemd.user.services.cliphist = {
      Unit.ConditionEnvironment = "WAYLAND_DISPLAY";
      Service.ExecStart = mkForce (
        lib.concatStringsSep " " [
          textPasteCmd
          watchCmd
        ]
      );
    };

    systemd.user.services.cliphist-images = {
      Unit.ConditionEnvironment = "WAYLAND_DISPLAY";
      Service.ExecStart = mkForce (
        lib.concatStringsSep " " [
          imagePasteCmd
          watchCmd
        ]
      );
    };

    looniversity.wayland.clipboard.wl-clipboard = enabled;
  };
}

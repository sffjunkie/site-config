{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.desktop.window_manager.lwm;

  reloadScript = pkgs.writeShellScriptBin "lwm_reload" ''
    ${pkgs.python3.pkgs.qtile}/bin/qtile cmd-obj -o cmd -f reload_config
  '';

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.desktop.window_manager.lwm = {
    enable = mkEnableOption "lwm";
    configPath = mkOption {
      type = types.str;
      default = "lwm";
    };

    dev = mkOption {
      type = types.bool;
      default = false;
      description = "Use the devleopment version of lwm";
    };

    python = mkOption {
      type = types.package;
      default = osConfig.looniversity.desktop.environment.lde.python;
    };

    extraPythonPackages = mkOption {
      type = types.functionTo (types.listOf types.package);
      description = ''
        A function that returns a list of packages from a package set
        to be added to the default packages required by qtile.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr (types.listOf types.path);
      default = null;
      description = ''
        systemd environment files to pass secrets needed by lwm.
      '';
    };
  };

  config = mkIf cfg.enable {
    sops.templates."api_key_conf" = {
      name = "20-location.conf";
      mode = "0444";
      content = ''
        OWM_API_KEY=${config.sops.placeholder."owm"}
      '';
    };

    looniversity.wayland.enable = true;
    looniversity.desktop.window_manager.lwm.dev = true;
    looniversity.desktop.window_manager.lwm.environmentFile = [
      config.sops.templates."api_key_conf".path
    ];

    environment.systemPackages = [
      reloadScript
    ];

    environment.sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "lwm";
    };

    systemd.user.services.lwm =
      let
        pyEnv = cfg.python.withPackages (
          ps:
          [
            ps.qtile
          ]
          ++ (cfg.extraPythonPackages ps)
        );
      in
      {
        description = "lwm - Looniversity window manager";
        documentation = [ "man:qtile(5)" ];

        environment.PATH = lib.mkForce null;
        environment.PYTHONPATH = lib.mkForce null;

        serviceConfig = {
          Type = "simple";
          ExecStart = "${pyEnv}/bin/qtile start --backend wayland --config %h/.config/${config.looniversity.desktop.window_manager.lwm.configPath}";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;

          EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
        };
      };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.terminal.ghostty;

  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.looniversity.terminal.ghostty = {
    enable = mkEnableOption "ghostty";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;

      installBatSyntax = true;

      settings = {
        font-family = "JetBrainsMono Nerd Font";
        font-size = 13;

        window-padding-x = 4;
        window-padding-y = 4;

        gtk-custom-css = "?${config.home.homeDirectory}/ghostty/custom.css";
      };

      systemd.enable = false;
    };

    xdg.configFile."ghostty/custom.css".text = ''
      tabbar {
        margin: -1rem;
      }

      tabbar tabbox {
        transform: translateY(-0.5rem);
      }
    '';

    # Recreate app-com.mitchellh.ghostty.service but with lde-session.target
    systemd.user.services."app-com.mitchellh.ghostty" = {
      Install = {
        WantedBy = [ "lde-session.target" ];
      };

      Service = {
        BusName = "com.mitchellh.ghostty";
        ExecStart = "${lib.getExe pkgs.ghostty} --gtk-single-instance=true --initial-window=false";
        ReloadSignal = "SIGUSR2";
        Type = "notify-reload";
      };

      Unit = {
        After = [
          "lde-session.target"
          "dbus.socket"
        ];
        Description = "Ghostty";
        Requires = "dbus.socket";
        X-SwitchMethod = "keep-old";
      };
    };

    xdg.configFile."systemd/user/app-com.mitchellh.ghostty.service.d/overrides.conf".text = ''
      [Unit]
      X-SwitchMethod=keep-old
      X-Reload-Triggers=${
        let
          storePathOf = name: config.xdg.configFile.${name}.source;
        in
        toString (
          lib.optionals (config.programs.ghostty.settings != { }) [ (storePathOf "ghostty/config") ]
          ++ lib.mapAttrsToList (name: _: storePathOf "ghostty/themes/${name}") config.programs.ghostty.themes
        )
      }
    '';

    dbus.packages = [ config.programs.ghostty.package ];
  };
}

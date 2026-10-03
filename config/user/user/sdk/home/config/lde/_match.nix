{
  formatter,
  ...
}:
formatter.generate "desktop-match" {
  match = {
    defs = {
      brave = [
        {
          appid = "brave-browser";
        }
      ];
      chrome = [ { appid = "chromium"; } ];
      darksouls = [ { appid = "steam_app_570940"; } ];
      darksoulsII = [ { appid = "steam_app_335300"; } ];
      darktable = [ { appid = "Darktable"; } ];
      eldenring = [ { appid = "steam_app_1245620"; } ];
      firefox = [ { appid = "firefox"; } ];
      gimp = [ { appid = "Gimp-\d+.\d+"; } ];
      gnome-calculator = [ { appid = "org\.gnome\.Calculator"; } ];
      gnome-characters = [ { appid = "org\.gnome\.Characters"; } ];
      inkscape = [ { appid = "org\.inkscape\.Inkscape"; } ];
      obsidian = [ { appid = "obsidian"; } ];
      pavucontrol = [ { appid = "org.pulseaudio.pavucontrol"; } ];
      vscode = [
        { appid = "code"; }
        { appid = "code-url-handler"; }
      ];
      waypaper = [ { appid = "waypaper"; } ];
      freecad-open = [
        {
          appid = "org.freecad.FreeCAD";
          title = "Open document";
        }
      ];
      orca-slicer-saveas = [
        {
          appid = "orca-slicer";
          title = "Save file as";
        }
      ];
      slurm = [
        {
          appid = "com.mitchellh.ghostty";
          title = "slurm";
        }
      ];
      steam = [ { appid = "steamwebhelper"; } ];
      xdg-desktop-portal-gtk = [ { appid = "xdg-desktop-portal-gtk"; } ];
      wdisplays = [ { appid = "wdisplays"; } ];
      qtcreator = [ { appid = "org.qt-project.qtcreator"; } ];
    };
  };
}

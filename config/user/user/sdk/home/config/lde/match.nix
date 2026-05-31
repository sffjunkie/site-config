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
      darktable = [ { appid = "Darktable"; } ];
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
      xdg-desktop-portal-gtk = [ { appid = "xdg-desktop-portal-gtk"; } ];
    };
  };
}

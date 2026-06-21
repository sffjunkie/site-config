{
  formatter,
  ...
}:
formatter.generate "desktop-floating" {
  floating.matches = [
    { match = "freecad-open"; }
    { match = "gnome-calculator"; }
    { match = "gnome-characters"; }
    { match = "orca-slicer-saveas"; }
    { match = "pavucontrol"; }
    { match = "slurm"; }
    { match = "waypaper"; }
    {
      match = "wdisplays";
      size = [
        1024
        800
      ];
    }
    { match = "xdg-desktop-portal-gtk"; }
  ];
}

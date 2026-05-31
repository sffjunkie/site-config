{
  formatter,
  ...
}:
formatter.generate "desktop-floating" {
  floating.matches = [
    "freecad-open"
    "gnome-calculator"
    "gnome-characters"
    "orca-slicer-saveas"
    "pavucontrol"
    "slurm"
    "waypaper"
    "xdg-desktop-portal-gtk"
  ];
}

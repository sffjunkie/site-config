{
  formatter,
  ...
}:
formatter.generate "desktop-layout" {
  layout = {
    default_layouts = [
      "max"
      "monadtall"
    ];

    base = {
      margin = 8;
      border_width = 4;
      border_rounded = true;
    };

    layouts.monadtall = {
      change_ratio = 0.05;
    };
  };
}

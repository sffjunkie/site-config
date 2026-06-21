{
  formatter,
  ...
}:
let
  margin = 8;
in
formatter.generate "desktop-bar" {
  bar = {
    top = {
      height = 38;
      margin = [
        margin
        margin
        0
        margin
      ];
      opacity = 0.8;
    };
    bottom = {
      height = 38;
      margin = [
        0
        margin
        margin
        margin
      ];
      opacity = 0.8;
    };
  };
}

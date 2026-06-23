{
  formatter,
  ...
}:
formatter.generate "desktop-group" {
  group = {
    layout = "max";
    layouts = [
      "max"
      "monadtall"
    ];
    decoration = "superscript";
    defs = [
      {
        name = "WWW";
        layout = "monadtall";
        matches = [
          "brave"
          "chrome"
          "firefox"
        ];
      }
      {
        name = "BRAIN";
        layout = "max";
        matches = [ "obsidian" ];
      }
      {
        name = "CODE";
        layout = "max";
        matches = [ "vscode" ];
      }
      {
        name = "TERM";
        layout = "monadtall";
      }
      {
        name = "MISC";
        layout = "max";
        matches = [ "qtcreator" ];
      }
    ];
  };
}

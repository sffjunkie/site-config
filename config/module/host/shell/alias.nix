{
  config = {
    environment.shellAliases = {
      jc = "journalctl -xeu";
      jcu = "journalctl --user -xeu";

      sc = "systemctl";
      scu = "systemctl --user";

      scc = "systemctl cat";
      scuc = "systemctl --user cat";

      sci = "systemctl status";
      scui = "systemctl --user status";

      scr = "systemctl start";
      scur = "systemctl --user start";

      scs = "systemctl stop";
      scus = "systemctl --user stop";
    };
  };
}

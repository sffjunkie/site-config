{
  config = {
    systemd.tmpfiles.settings."10-nixos-directory"."/etc/nixos".d = {
      group = "admins";
      mode = "0775";
    };
  };
}

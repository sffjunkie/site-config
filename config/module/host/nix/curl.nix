{
  config = {
    environment.etc."nix/nix.curl.conf" = {
      text = "curlOpts = --ipv4";
      mode = "0444";
    };
  };
}

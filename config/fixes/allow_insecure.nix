{ lib, ... }:
{
  config = {
    nixpkgs.config.allowInsecurePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "minio" # allow minio until I've replaced it with Garage
        "libsoup"
        "mbedtls"
      ];
  };
}

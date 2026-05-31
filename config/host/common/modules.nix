{ lib, ... }:
let
  inherit (lib.looniversity) enabled;
in
{
  config = {
    looniversity = {
      security = {
        age = enabled;
        sops = enabled;
        polkit = enabled;
      };
    };
  };
}

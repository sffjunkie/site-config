{ lib, ... }:
let
  inherit (lib.looniversity) enabled;
in
{
  config = {
    looniversity = {
      security = {
        polkit = enabled;
      };
    };
  };
}

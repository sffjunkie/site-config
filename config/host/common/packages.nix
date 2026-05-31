{ pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.git
      pkgs.git-lfs
      pkgs.nano
      pkgs.pciutils
      pkgs.pipx
      pkgs.psmisc
      pkgs.unzip
      pkgs.usbutils
      pkgs.zip
      pkgs.base16-schemes
    ];
  };
}

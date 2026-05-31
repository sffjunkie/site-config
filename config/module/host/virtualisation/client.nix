{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.virtualisation.client;

  uris = lib.concatStringsSep ",\n" (
    map (
      elem: "\"${elem.name}=qemu+ssh://${elem.user}@${elem.host}/system\""
    ) config.looniversity.virtualisation.client.uri_aliases
  );

  libvirtConf = pkgs.writeTextFile {
    name = "libvirt.conf";
    text = lib.concatStringsSep "\n" [
      "uri_aliases = ["
      uris
      "]"
    ];
  };

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.virtualisation.client = {
    enable = mkEnableOption "virtualisation client config";
    uri_aliases = mkOption {
      type = types.listOf (types.attrsOf types.str);
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    environment = {
      etc = {
        "libvirt/libvirt.conf" = lib.mkIf (config.looniversity.virtualisation.client.uri_aliases != [ ]) {
          source = libvirtConf;
        };
      };

      variables = {
        LIBVIRT_DEFAULT_URI = "qemu:///system";
      };
    };

    environment.systemPackages = [
      pkgs.spice-gtk
      pkgs.virt-manager
      pkgs.virt-viewer
      pkgs.python3Packages.libvirt
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.virtualisation.server;

  inherit (lib)
    mkEnableOption
    mkIf
    ;
  inherit (lib.looniversity) enabled;
in
{
  options.looniversity.virtualisation.server = {
    enable = mkEnableOption "virtualisation server config";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm = enabled;
        };
      };
      spiceUSBRedirection = enabled;
    };

    environment = {
      variables = {
        LIBVIRT_DEFAULT_URI = "qemu:///system";
      };
    };

    environment.systemPackages = [
      pkgs.spice
      pkgs.spice-protocol
      pkgs.python3Packages.libvirt
    ];

    systemd.services.libvirt-default-network = {
      description = "Start libvirt default network";
      after = [ "libvirtd.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        ExecStart = [
          "${pkgs.libvirt}/bin/virsh net-define /var/lib/libvirt/qemu/networks/default.xml"
          "${pkgs.libvirt}/bin/virsh net-autostart default"
        ];
        ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
        User = "root";
      };
    };
  };
}

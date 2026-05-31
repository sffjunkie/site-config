{
  config = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-partuuid/ae404967-9818-47bb-bb8f-d6708bc3f26b";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-partuuid/4cb76b78-6f88-4473-bc36-52dd98b7e11c";
        fsType = "vfat";
      };

      "/nix" = {
        device = "tank0/nix";
        fsType = "zfs";
      };

      "/var" = {
        device = "tank0/var";
        fsType = "zfs";
      };

      "/home" = {
        device = "tank1/home";
        fsType = "zfs";
      };
    };

    swapDevices = [ ];
  };
}

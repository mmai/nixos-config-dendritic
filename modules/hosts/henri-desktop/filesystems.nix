{
  flake.modules.nixos.henri-desktop = {

    fileSystems."/" =
      {
        device = "/dev/disk/by-uuid/a732d634-4874-401b-8533-0dfa92791be4";
        fsType = "ext4";
      };

    fileSystems."/home" =
      {
        device = "/dev/disk/by-label/bigdata";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      {
        #device = "/dev/disk/by-uuid/7C82-B0DB";
        device = "/dev/disk/by-uuid/7B2A-6E93";
        fsType = "vfat";
      };

    swapDevices =
      [{ device = "/dev/disk/by-uuid/eb816ea9-30df-4637-84d3-18d78510d77a"; }];

  };
}

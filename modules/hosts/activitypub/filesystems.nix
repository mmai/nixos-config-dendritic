{
  flake.modules.nixos.activitypub = {

    fileSystems."/" =
      {
        device = "/dev/disk/by-uuid/39f7ac9a-3ad7-42e6-843d-13e150970cfe";
        fsType = "ext4";
      };
    fileSystems."/data/" =
      {
        device = "/dev/disk/by-uuid/7ab575c5-ef3d-4f01-850d-81b2559685ea";
        fsType = "ext4";
        mountPoint = "/data";
      };

    fileSystems."/media/" =
      {
        device = "/dev/disk/by-uuid/eeb6b6db-9c4a-42f1-b28e-dcef90f7876f";
        fsType = "ext4";
        mountPoint = "/media";
      };

    swapDevices =
      [{ device = "/dev/disk/by-uuid/a6f0441d-80a3-4148-8bfa-d38578d7942f"; }];
  };
}

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

    # Steam library drive: mount deterministically at boot, at the same path
    # udisks/GNOME would otherwise use, so it's ready before Steam starts
    # (avoids Steam dropping the library folder when it starts before the
    # drive gets auto-mounted).
    fileSystems."/run/media/henri/LexarExt4" =
      {
        device = "/dev/disk/by-uuid/4c4e8b2f-30be-4a5e-8968-ac8463293fe7";
        fsType = "ext4";
        options = [ "nofail" "x-gvfs-show" ];
      };

  };
}

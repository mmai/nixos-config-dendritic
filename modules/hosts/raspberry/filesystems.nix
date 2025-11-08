{
  flake.modules.nixos.raspberry = {

    fileSystems."/" =
      {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        options = [ "noatime" ];
      };

    fileSystems."/media" =
      {
        device = "/dev/disk/by-label/sonata";
        fsType = "ext4";
        options = [ "noatime" ];
      };

  };
}

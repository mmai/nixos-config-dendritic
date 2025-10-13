{
  flake.modules.nixos.henri-atixnet-laptop = {

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5d9c5f22-5528-4838-9b98-51083718f803";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/C46C-2809";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/fb6647bb-8210-4c7b-a85c-014a529812b2"; }
    ];

  };
}

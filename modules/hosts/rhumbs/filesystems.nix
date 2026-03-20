{
  flake.modules.nixos.rhumbs = {

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3cdae94e-e109-45e2-a1fc-dff6fe1c9548";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/c7dac4ea-8da8-486b-9106-3cc737b91d98"; }
    ];
  };
}

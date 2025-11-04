{
  flake.modules.nixos.raspberry = {

    fileSystems."/" =
      {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        options = [ "noatime" ];
      };

    # fileSystems."/nix/store" =
    #   {
    #     device = "/nix/store";
    #     fsType = "none";
    #     options = [ "bind" ];
    #   };
    #
    # swapDevices = [ ];
  };
}

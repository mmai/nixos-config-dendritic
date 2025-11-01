{
  flake.modules.nixos.activitypub =
    { lib, modulesPath, ... }:
    {

      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        (modulesPath + "/profiles/qemu-guest.nix")
      ];

      boot.initrd.availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "sd_mod"
        "sr_mod"
      ];

      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];

      nix.settings.max-jobs = lib.mkDefault 1;
    };
}

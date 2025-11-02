{
  flake.modules.nixos.bootable =
    { lib, ... }:
    {
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    };

  flake.modules.nixos.bootable-grub =
    { lib, ... }:
    {
      # grub (when no /boot partition is available)
      boot.loader.grub.enable = true;
      boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
    };
}

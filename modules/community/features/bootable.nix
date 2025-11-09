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

  flake.modules.nixos.bootable-extlinux =
    { lib, ... }:
    {
      # extlinux (for raspberry-pi)
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      boot.loader = {
        grub.enable = false;
        systemd-boot.enable = false;
        generic-extlinux-compatible.enable = true;
      };
    };
}

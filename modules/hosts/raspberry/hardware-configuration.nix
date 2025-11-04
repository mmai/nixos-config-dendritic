{
  flake.modules.nixos.raspberry =
    { lib, modulesPath, ... }:
    {

      imports = [
        # This module installs the firmware
        (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
      ];

      # These options make the sd card image build faster
      boot.supportedFilesystems.zfs = lib.mkForce false;
      sdImage.compressImage = false;

      environment.systemPackages = with pkgs; [
        libraspberrypi
        raspberrypi-eeprom
      ];

      hardware.enableRedistributableFirmware = true;

      # Replace networkd with NetworkManager at your discretion
      networking.useNetworkd = true;
      systemd = {
        network = {
          enable = true;

          networks."10-lan" = {
            # This is the correct interface name on my raspi 4b
            matchConfig.Name = "end0";

            networkConfig.DHCP = "yes";
            linkConfig.RequiredForOnline = "routable";
          };
        };
      };

    };
}

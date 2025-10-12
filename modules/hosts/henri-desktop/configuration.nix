#############################################################
#
#  Henri Desktop
#  NixOS running on MSI MS-7A71 - i5-7600K x 4 - NVIDIA GeForce GTX 1070
#
###############################################################

{ inputs, pkgs, ... }:
let
  flake.modules.nixos.henri-desktop.imports = with inputs.self.modules.nixos; [
    kvm-intel
    henri-desktop-unfree
    nvidia
    henri
    gnome-desktop
    desktop
    coding
    leisure
    printing
    home_network
    sync-notes
    msmtp # mailtrap
  ];

  henri-desktop-unfree = inputs.self.lib.unfree-module [
    "nvidia-x11"
    "nvidia-settings"
  ];

  home_network = {
    # local network
    networking.extraHosts =
      ''
        192.168.1.10 home.rhumbs.fr
      '';

    fileSystems."/mnt/diskstation/videos" = {
      device = "diskstation:/volume1/video";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };

    fileSystems."/mnt/diskstation/music" = {
      device = "diskstation:/volume1/music";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };

    fileSystems."/mnt/diskstation/data" = {
      device = "diskstation:/volume1/data";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };
  };

  msmtp = {
    environment.etc =
      let msmtprc = pkgs.writeText "msmtprc"
        ''
          account mailtrap
          from henri@bourcereau.fr
          host smtp.mailtrap.io
          port 2525
          user 7d0baad1433da6
          password c59e56e197f524
          tls on
          auth plain

          account default : mailtrap
        '';
      in
      {
        "msmtprc".source = msmtprc;
      };
  };

in
{
  inherit flake;
}

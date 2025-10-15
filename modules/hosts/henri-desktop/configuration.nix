#############################################################
#
#  Henri Desktop
#  NixOS running on MSI MS-7A71 - i5-7600K x 4 - NVIDIA GeForce GTX 1070
#
###############################################################

{ inputs, ... }:
let
  flake.modules.nixos.henri-desktop.imports =
    [ inputs.nixos-rocksmith.nixosModules.default ] ++ (with inputs.self.modules.nixos; [
      # with inputs.self.modules.nixos; [
      kvm-intel
      henri
      home_network

      henri-desktop-unfree
      nvidia
      gnome-desktop
      desktop
      coding
      leisure
      printing
      sync-notes
      msmtp # mailtrap
      # ];
    ]);

  henri-desktop-unfree = inputs.self.lib.unfree-module [
    "nvidia-x11"
    "nvidia-settings"
    "steam"
    "steam-unwrapped"
    "teamviewer"
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

  msmtp = { pkgs, ... }: {
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

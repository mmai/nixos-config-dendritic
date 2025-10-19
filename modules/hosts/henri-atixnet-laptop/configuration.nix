#############################################################
#
#  Henri Atixnet Laptop
#  LENOVO ThinkPad X1 Carbon G10 
#  Intel Core i5-1235U 14p WUXGA 16Go 256Go SSD M.2 2280 Iris Xe Graphics W10P/W11P
#
###############################################################

{ inputs, pkgs, ... }:
let
  flake.modules.nixos.henri-atixnet-laptop.imports = with inputs.self.modules.nixos; [
    kvm-intel
    henri-atixnet-laptop-unfree
    # nvidia
    henri
    gnome-desktop
    desktop
    coding
    # leisure
    # printing
    sync-notes
    msmtp # mailtrap
  ];

  henri-atixnet-laptop-unfree = inputs.self.lib.unfree-module [
    "nvidia-x11"
    "nvidia-settings"
    "teamviewer"
  ];

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

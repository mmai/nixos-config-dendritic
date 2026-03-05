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
    devices
    henri-atixnet-laptop-unfree
    keyboardLafayette
    kanata
    app-cli-minimal
    # nvidia
    henri
    # autologin
    server-ssh
    dankMaterialShell-desktop
    gnome-desktop
    desktop
    coding
    # leisure
    # printing
    sync-notes
    msmtp # mailtrap
    custompkgs
  ];

  henri-ssh-keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVKKqG2/2Vi3KS5PrBIRLZ8m6J4thXCWY2bsuBWHOQ67RSYzEufCD9ygcN0foXEYN5e2+Mqo8BquVbtFLXFsBD5RfMcN93SmP/XjeMI9IbKIikZ8qkpxgnh4XF8e6aRpaCao/hio3X+uY0OWBcwSqveOf26ou5C5fMDFSvDpMRwQTpalT8hsoQC3KiHSuenFrzDkwEscXSioecmkBG/brVEBMyYfUcMOFUWmq9lFmfsDRC4dfS3sAFxthnVhQ8Yl4Lzox5v8uRFpROy4/vHcelbZDsXVl59uQnoJblhoIJob5NWnp33x3vPRz1ycPcGxNSZLUHCBf01f00ueYNU5EB henri@henri-desktop"
  ];

  server-ssh = {
    networking.firewall.allowedTCPPorts = [ 22 ];
    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = henri-ssh-keys;

    # Add your username and ssh key
    users.users.henri = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = henri-ssh-keys;
    };

    # Our user doesn't have a password, so we let them
    # do sudo without one
    security.sudo.wheelNeedsPassword = false;
  };


  henri-atixnet-laptop-unfree = inputs.self.lib.unfree-module [
    "nvidia-x11"
    "nvidia-settings"
    "teamviewer"
    "hyperspeedcube"
  ];

  custompkgs = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        hyperspeedcube
      ];
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

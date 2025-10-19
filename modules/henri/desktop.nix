{ ... }:
let
  flake.modules.nixos.desktop =
    { config, lib, pkgs, stdenv, ... }:
    {

      # Gnome shell extensions with browsers
      services.gnome.gnome-browser-connector.enable = true;
      programs.firefox.nativeMessagingHosts.packages = [
        pkgs.gnome-browser-connector
      ];

      services.teamviewer.enable = true;

      networking.firewall.allowedTCPPorts = [ 8010 ]; # allow streaming to chromecast devices (vlc)

      environment.systemPackages = with pkgs; [

        # ---------- the forever quest for a good email client -----------
        #  since 19.09 default mail client in gnome is geary
        thunderbird
        # evolution # frequently loose connection, copy sent mails twice in history
        # mailnag # don't work ? new mails on Maildir folders notification (for use with mbsync+mutt)
        # mailspring # mail client (custom package) (evolution trop buggé) # trop lourd

        # pour X11
        xorg.xkill
        xdotool # manipulate gui windows from command line 
        xdragon # drag & drop from command line

        alacritty # faster terminal with sane default (and zoomable) ; needs > 4.0

        # appimage-run # enable execution of .AppImage packages
        appimage-run

        vlc # video viewer
        libreoffice
        firefox
        (chromium.override {
          commandLineArgs = "--load-media-router-component-extension=1"; # this allows to stream to chromecast devices from the browser
        })
        tor-browser-bundle-bin # TOR browser
        transmission_4-gtk
        hexchat # desktop chat client
        element-desktop # matrix client

        # Included in gnome3
        #   pdf viewer : evince (alternatives : zathura, okular)
        xournalpp # manipulation de pdf : permet d'ajouter une signature png
        pdfarranger # pour rotation des pages, retailler, etc.

        gimp
        krita
        inkscape

        gitg
        meld

        gparted
        keepassxc
        qtpass # pass gui
        filezilla
        # unetbootin # live linux usb creator # not supported on aarch64/rapsberry pi (requires syslinux)

        wireshark
        # missing : gpick

        # gnome apps installed in gnome.nix : alternatives available for other envs ?
        # gnome.cheese # take photos & videos with webcam (launch with sudo ?)
        # gcolor2 # simple color selector
        # gnome.seahorse # to get rid of the "gnome default keyring locked" prompt at startup
      ];

    };
in
{
  inherit flake;
}

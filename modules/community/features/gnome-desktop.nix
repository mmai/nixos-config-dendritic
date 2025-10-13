{
  flake.modules.nixos.gnome-desktop = { pkgs, ... }:
    {
      # Enable the GNOME Desktop Environment.
      services.displayManager = {
        gdm = {
          enable = true;
          wayland = false; # disable wayland in order to allow microsoft teams to share desktop ?
        };
      };

      services.desktopManager.gnome = {
        enable = true;
        extraGSettingsOverrides = ''
          [org.gnome.shell.app-switcher]
          current-workspace-only=true

          [org.gnome.desktop.background]
          show-desktop-icons=true
        '';
      };

      # set defaults apps (especially image viewer so that it is not the last software used which become the default (I look at you Gimp))
      # for a more complete config, see https://src.fedoraproject.org/rpms/shared-mime-info/blob/rawhide/f/mimeapps.list
      environment.etc."xdg/mimeapps.list" = {
        text = ''
            [Default Applications]
            image/bmp=org.gnome.eog.desktop;
          image/gif=org.gnome.eog.desktop;
          image/jpeg=org.gnome.eog.desktop;
          image/jpg=org.gnome.eog.desktop;
          image/pjpeg=org.gnome.eog.desktop;
          image/png=org.gnome.eog.desktop;
          image/tiff=org.gnome.eog.desktop;
          image/x-bmp=org.gnome.eog.desktop;
          image/x-gray=org.gnome.eog.desktop;
          image/x-icb=org.gnome.eog.desktop;
          image/x-ico=org.gnome.eog.desktop;
          image/x-png=org.gnome.eog.desktop;
          image/x-portable-anymap=org.gnome.eog.desktop;
          image/x-portable-bitmap=org.gnome.eog.desktop;
          image/x-portable-graymap=org.gnome.eog.desktop;
          image/x-portable-pixmap=org.gnome.eog.desktop;
          image/x-xbitmap=org.gnome.eog.desktop;
          image/x-xpixmap=org.gnome.eog.desktop;
          image/x-pcx=org.gnome.eog.desktop;
          image/svg+xml=org.gnome.eog.desktop;
          image/svg+xml-compressed=org.gnome.eog.desktop;
          image/vnd.wap.wbmp=org.gnome.eog.desktop;
          image/x-icns=org.gnome.eog.desktop;
        '';
      };

      environment.gnome.excludePackages = with pkgs; [ geary ];
      environment.systemPackages = with pkgs; [
        gnome-tweaks
        # gnomeExtensions.dash-to-panel # broken in nixos 20.09, enable it from https://extensions.gnome.org/extension/1160/dash-to-panel/ instead
        # gnomeExtensions.timepp # pomodoro, timetracker, etc. => marked broken in nixos 20.03
        # gnomeExtensions.gtk-title-bar # not yet packaged in nixos
        gnomeExtensions.system-monitor-2

        cheese # take photos & videos with webcam (launch with sudo ?)
        gcolor3 # simple color selector
        seahorse # to get rid of the "gnome default keyring locked" prompt at startup
      ];

      # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;
    };
}

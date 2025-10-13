{ ... }:
let
  flake.modules.homeManager.henri =
    { pkgs, lib, ... }:
    {
      gtk = {
        enable = true;

        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };

        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };

        gtk3.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };

        gtk4.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };

      };

      home.sessionVariables.GTK_THEME = "adw-gtk3-dark";

      dconf.settings = {
        "org/nome/desktop/input-sources" = {
          show-all-sources = true;
          sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "us+intl" ]) (lib.hm.gvariant.mkTuple [ "xkb" "lafayette" ]) ];
        };

        "org/gnome/desktop/wm/keybindings" = {
          # ergol
          # "maximize" = [ "<Super>ISO_Level5_Latch" ];
          # "move-to-workspace-1" = [ "<Super>q" ];
          # "move-to-workspace-2" = [ "<Super>c" ];
          # "move-to-workspace-3" = [ "<Super>o" ];
          # "move-to-workspace-4" = [ "<Super>p" ];
          # "switch-to-workspace-1" = [ "<Super>a" ];
          # "switch-to-workspace-2" = [ "<Super>s" ];
          # "switch-to-workspace-3" = [ "<Super>e" ];
          # "switch-to-workspace-4" = [ "<Super>n" ];

          # qwerty
          "maximize" = [ "<Super>o" ];
          "move-to-workspace-1" = [ "<Super>q" ];
          "move-to-workspace-2" = [ "<Super>w" ];
          "move-to-workspace-3" = [ "<Super>e" ];
          "move-to-workspace-4" = [ "<Super>r" ];
          "switch-to-workspace-1" = [ "<Super>a" ];
          "switch-to-workspace-2" = [ "<Super>s" ];
          "switch-to-workspace-3" = [ "<Super>d" ];
          "switch-to-workspace-4" = [ "<Super>f" ];
        };
      };

    };
in
{
  inherit flake;
}

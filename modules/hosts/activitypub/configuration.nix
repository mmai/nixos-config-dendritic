#############################################################
#
#  Activitypub on Hetzner CX21
#
###############################################################

{ inputs, ... }:
let
  secrets = import ./_secrets.nix;
  flake.modules.nixos.activitypub.imports =
    (with inputs.self.modules.nixos; [
      hetzner-boot
      optimize-space
      server-ssh
      server-security
      locale-minimal
      app-cli-minimal

      navidrome
      # activitypub-prometheus
    ]);

  optimize-space =
    {
      # Clean /tmp on boot.
      boot.tmp.cleanOnBoot = true;
      # Automatically optimize the Nix store to save space by hard-linking identical files together.
      nix.settings.auto-optimise-store = true;
      # Limit the systemd journal to 100 MB of disk or the last 7 days of logs, whichever happens first.
      services.journald.extraConfig = ''
        SystemMaxUse=100M
        MaxFileSec=7day
      '';
    };

  locale-minimal = {
    i18n.defaultLocale = "fr_FR.UTF-8";
    time.timeZone = "Europe/Paris";
  };

  hetzner-boot = {
    # boot.loader.systemd-boot.enable = false;
    # boot.loader.grub.enable = true;
    # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
    console.font = "Lat2-Terminus16";
  };

  server-security = {
    services.fail2ban.enable = true;
  };

  server-ssh = {
    networking.firewall.allowedTCPPorts = [ 22 ];
    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVKKqG2/2Vi3KS5PrBIRLZ8m6J4thXCWY2bsuBWHOQ67RSYzEufCD9ygcN0foXEYN5e2+Mqo8BquVbtFLXFsBD5RfMcN93SmP/XjeMI9IbKIikZ8qkpxgnh4XF8e6aRpaCao/hio3X+uY0OWBcwSqveOf26ou5C5fMDFSvDpMRwQTpalT8hsoQC3KiHSuenFrzDkwEscXSioecmkBG/brVEBMyYfUcMOFUWmq9lFmfsDRC4dfS3sAFxthnVhQ8Yl4Lzox5v8uRFpROy4/vHcelbZDsXVl59uQnoJblhoIJob5NWnp33x3vPRz1ycPcGxNSZLUHCBf01f00ueYNU5EB henri@henri-desktop"
      # laptop
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3TrbolMIPXyP7/kb06hNL5meec5MhAsYLbSb2XFyzToTCduLYRsI+hQhbTO5KmeH6WY72NXJWxEYn+iUWcrG39e6gLjVDIoDXSU6DYRamU3GdnZ3Vj5tNXCDxv7ISXLJWwvL9oAESn73Vb2GLBrrGK7JqIUAdv7ow9YFKL50HmKu9BZqYyfdpqGLNEL2edjGFpsFTDqeDGle0AOsl5Pey0TFPAfG7omV4/wJMHMWhjk+YuLdAZq3L118Q597CCv+RRYdUZWz/pu2sHzrdG0ZudYcS+JHSbQRR00YtqmJRI5JwL3s9v6IqvcL8W5ULNS5z9V0zoQrt69j2Soz4/Fe/ henri@henri-UX31A"
      # Diskstation (pour backups)
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsNVOt0BWFlLTTj1I+9UU5lJe/D/dhTQxfQRVArh2dm9mYAyb4xQOZ4W+6Zu49atJdArEHhzbMJ8utyYpHRYhHwVvBSliuVxSFxOxqSfX96teK+hHHs6OQYVOZUVOjISK6GEL9U6NC7l0UrwaApMXWJYfyxHNlV6iudjrECFmfOHBp5biSLhUdMKo7Pqvhe0yBUupi9gf6ba+GuoDtrL0KdZQmUC4Itzs0lNUKbswev5T1NApBqPlXN29jnwC4nQIiYy3dT55xhXuWmkXBdLZChtunLLsnrjIrPJZKOjNTmeSXieYwNxhmK73W+NkDNA1JO85rhVJjfxkakLyyHqnF admin@DiskStation"
    ];

  };

  navidrome = {
    services.navidrome = {
      enable = true;
      settings = {
        MusicFolder = "/media/music";
        LastFM.ApiKey = secrets.lastFM.navidromeApiKey;
        LastFM.Secret = secrets.lastFM.navidromeSecret;
      };
    };
    services.nginx = {
      enable = true;
      clientMaxBodySize = "100m";
      virtualHosts."music.rhumbs.fr" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:4533"; # navidrome default listening port
        };
      };
    };

    # http, https
    # for prometheus exporters (node, postgres) navidrome, add :  3021 3022
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    security.acme = {
      defaults.email = "henri.bourcereau@gmail.com";
      acceptTerms = true;
    };
  };

  activitypub-prometheus = {
    services.prometheus.exporters =
      let
        listenAddress = "10.0.0.3"; # private network prometheus collector address ('rhumbs' on Hetzner)
      in
      {
        node = {
          enable = true;
          port = 3021;
          listenAddress = listenAddress;
          enabledCollectors = [ "systemd" ]; # The collectors listed here are enabled in addition to the default ones.
        };
        postgres = {
          enable = true;
          port = 3022;
          listenAddress = listenAddress;
          runAsLocalSuperUser = true;
          extraFlags = [ "--auto-discover-databases" ];
        };
      };
  };

in
{
  inherit flake;
}

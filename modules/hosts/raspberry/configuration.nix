#############################################################
#
# Raspberry Pi 4
#
###############################################################

{ inputs, ... }:
let
  sshPort = 2822;
  flake.modules.nixos.raspberry.imports =
    [ inputs.sops-nix.nixosModules.sops ] ++ (with inputs.self.modules.nixos; [
      sops-secrets
      optimize-space
      server-ssh
      server-security
      server-monitoring
      # server-smtp
      locale-minimal
      app-cli-minimal

      navidrome
      #immich
      trictrac
      # activitypub-prometheus
      miniflux
      linkding
    ]);

  sops-secrets = {
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    sops.defaultSopsFile = ./_secrets/secrets.yaml;
    sops.secrets."beszel_agent_env" = { };
    sops.secrets."navidrome_env" = { };
    sops.secrets."smtp/pass" = { };
    sops.secrets."miniflux_admin_credentials" = { };
    sops.secrets."linkding_env" = { };
  };

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

  server-security = {
    services.fail2ban.enable = true;
  };

  henri-ssh-keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVKKqG2/2Vi3KS5PrBIRLZ8m6J4thXCWY2bsuBWHOQ67RSYzEufCD9ygcN0foXEYN5e2+Mqo8BquVbtFLXFsBD5RfMcN93SmP/XjeMI9IbKIikZ8qkpxgnh4XF8e6aRpaCao/hio3X+uY0OWBcwSqveOf26ou5C5fMDFSvDpMRwQTpalT8hsoQC3KiHSuenFrzDkwEscXSioecmkBG/brVEBMyYfUcMOFUWmq9lFmfsDRC4dfS3sAFxthnVhQ8Yl4Lzox5v8uRFpROy4/vHcelbZDsXVl59uQnoJblhoIJob5NWnp33x3vPRz1ycPcGxNSZLUHCBf01f00ueYNU5EB henri@henri-desktop"
    # laptop
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3TrbolMIPXyP7/kb06hNL5meec5MhAsYLbSb2XFyzToTCduLYRsI+hQhbTO5KmeH6WY72NXJWxEYn+iUWcrG39e6gLjVDIoDXSU6DYRamU3GdnZ3Vj5tNXCDxv7ISXLJWwvL9oAESn73Vb2GLBrrGK7JqIUAdv7ow9YFKL50HmKu9BZqYyfdpqGLNEL2edjGFpsFTDqeDGle0AOsl5Pey0TFPAfG7omV4/wJMHMWhjk+YuLdAZq3L118Q597CCv+RRYdUZWz/pu2sHzrdG0ZudYcS+JHSbQRR00YtqmJRI5JwL3s9v6IqvcL8W5ULNS5z9V0zoQrt69j2Soz4/Fe/ henri@henri-UX31A"
    # Diskstation (pour backups)
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsNVOt0BWFlLTTj1I+9UU5lJe/D/dhTQxfQRVArh2dm9mYAyb4xQOZ4W+6Zu49atJdArEHhzbMJ8utyYpHRYhHwVvBSliuVxSFxOxqSfX96teK+hHHs6OQYVOZUVOjISK6GEL9U6NC7l0UrwaApMXWJYfyxHNlV6iudjrECFmfOHBp5biSLhUdMKo7Pqvhe0yBUupi9gf6ba+GuoDtrL0KdZQmUC4Itzs0lNUKbswev5T1NApBqPlXN29jnwC4nQIiYy3dT55xhXuWmkXBdLZChtunLLsnrjIrPJZKOjNTmeSXieYwNxhmK73W+NkDNA1JO85rhVJjfxkakLyyHqnF admin@DiskStation"
  ];

  server-ssh = {
    networking.firewall.allowedTCPPorts = [ sshPort ];
    services.openssh = {
      enable = true;
      listenAddresses = [
        { addr = "0.0.0.0"; port = sshPort; }
      ];
    };
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

  server-monitoring = { config, ... }: {
    services.beszel.agent = {
      enable = true;
      environmentFile = config.sops.secrets."beszel_agent_env".path;
    };
  };

  trictrac = { config, pkgs, ... }: {
    imports = [ inputs.trictrac.nixosModule ];
    nixpkgs.overlays = [ inputs.trictrac.overlay ];
    services.trictrac = {
      enable = true;
      apiPort = 8080; # default
      protocol = "https";
      hostname = "trictrac.rhumbs.fr";
      smtp = {
        tls = true;
        from = "noreply@trictrac.rhumbs.fr";
        host = "smtp.resend.com";
        user = "resend";
        passwordFile = config.sops.secrets."smtp/pass".path;
      };
    };

    environment.systemPackages = [
      pkgs.goaccess # generate web stats from nginx access logs
    ];

    # ----- backups -----
    services.postgresqlBackup = {
      enable = true;
      databases = [ "trictrac" "miniflux" ]; # creates /var/backup/postgresql/trictrac.sql.gz, etc. nightly
    };

    services.borgbackup.jobs."trictrac" = {
      paths = [
        "/var/backup/postgresql/trictrac.sql.gz"
        "/var/lib/trictrac/GameConfig.json"
      ];
      repo = "ssh://borg@Diskstation/volume1/borgbackups/trictrac";
      startAt = "04:30"; # after postgresqlBackup which runs at 01:15 by default
      compression = "auto,zstd";
      environment.BORG_RSH = "ssh -i /root/.ssh/id_ed25519";
      encryption.mode = "none";
      prune.keep = {
        daily = 7;
        weekly = 4;
        monthly = 3;
      };
    };

  };

  navidrome = { config, ... }: {
    services.navidrome = {
      enable = true;
      settings = {
        MusicFolder = "/media/music";
      };
      environmentFile = config.sops.secrets."navidrome_env".path;
    };
    services.nginx = {
      enable = true;
      clientMaxBodySize = "100m";
      virtualHosts."rasp.rhumbs.fr" = {
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

  miniflux = { config, ... }: {
    services.miniflux = {
      enable = true;
      adminCredentialsFile = config.sops.secrets."miniflux_admin_credentials".path;
      config = {
        BASE_URL = "https://rss.rhumbs.fr";
        LISTEN_ADDR = "localhost:8082";
        INTEGRATION_ALLOW_PRIVATE_NETWORKS = "1"; # allow calling the linkding integration over localhost
      };
    };
    services.nginx = {
      enable = true;
      virtualHosts."rss.rhumbs.fr" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8082"; # miniflux default listening port
        };
      };
    };
    # http, https
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    security.acme = {
      defaults.email = "henri.bourcereau@gmail.com";
      acceptTerms = true;
    };

    services.borgbackup.jobs."miniflux" = {
      paths = [
        "/var/backup/postgresql/miniflux.sql.gz"
      ];
      repo = "ssh://borg@Diskstation/volume1/borgbackups/miniflux";
      startAt = "04:35"; # after postgresqlBackup which runs at 01:15 by default
      compression = "auto,zstd";
      environment.BORG_RSH = "ssh -i /root/.ssh/id_ed25519";
      encryption.mode = "none";
      prune.keep = {
        daily = 7;
        weekly = 4;
        monthly = 3;
      };
    };

  };

  linkding = { config, ... }:
    let domain = "link.rhumbs.fr";
    in
    {
      services.linkding = {
        enable = true;
        environmentFile = config.sops.secrets."linkding_env".path;
        settings = {
          LD_CSRF_TRUSTED_ORIGINS = "https://${domain}"; # otherwise login fails behind the nginx reverse proxy
        };
      };
      services.nginx = {
        enable = true;
        virtualHosts."${domain}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:9090"; # linkding default listening port
          };
        };
      };
      # http, https
      networking.firewall.allowedTCPPorts = [ 80 443 ];
      # allow local services like miniflux to access the service without being blocked by the LiveBox NAT
      networking.extraHosts =
        ''
          127.0.0.1 ${domain}
        '';

      security.acme = {
        defaults.email = "henri.bourcereau@gmail.com";
        acceptTerms = true;
      };

      services.borgbackup.jobs."linkding" = {
        paths = [
          "/var/lib/linkding"
        ];
        repo = "ssh://borg@Diskstation/volume1/borgbackups/linkding";
        startAt = "04:45";
        compression = "auto,zstd";
        environment.BORG_RSH = "ssh -i /root/.ssh/id_ed25519";
        encryption.mode = "none";
        prune.keep = {
          daily = 7;
          weekly = 4;
          monthly = 3;
        };
      };
    };

  immich =
    let
      port = 2283;
      mediaLocation = "/var/lib/immich"; # default but set here for reuse in borgbackup (don't know how to reference sevice.immich.mediaLocation from borgbackup config)
    in
    {
      users.users.immich.extraGroups = [ "video" "render" ];
      services.immich = {
        enable = true;
        mediaLocation = mediaLocation;
        port = port;
        accelerationDevices = null;
      };
      services.nginx = {
        enable = true;
        virtualHosts."pictures.rhumbs.fr" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://[::1]:${toString port}";
            proxyWebsockets = true;
            recommendedProxySettings = true;
            extraConfig = ''
                client_max_body_size 50000M;
              proxy_read_timeout   600s;
              proxy_send_timeout   600s;
              send_timeout         600s;
            '';
          };
        };

      };
      services.borgbackup.jobs."Immich" = {
        paths = mediaLocation;
        repo = "ssh://borg@Diskstation/volume1/borgbackups/immich";
        startAt = "Sat 04:00";
        compression = "auto,zstd";
        environment.BORG_RSH = "ssh -i /root/.ssh/id_ed25519";
        encryption.mode = "none";
        prune.keep = {
          last = 2;
        };
      };

    };


in
{
  inherit flake;
}

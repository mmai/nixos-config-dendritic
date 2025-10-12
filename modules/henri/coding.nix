{ ... }:
let
  flake.modules.nixos.coding =
    { config, lib, pkgs, ... }:
    {
      # enable /etc/hosts editing (/!\ config is reset at each config rebuild)
      environment.etc.hosts.mode = "0644";

      virtualisation.docker.enable = true;

      environment.systemPackages =
        let
          php' = pkgs.php.buildEnv {
            extensions = { enabled, all }: enabled ++ [ all.xsl all.xdebug ]; # xsl needed by symfony
            extraConfig = ''
              memory_limit = 2G
              post_max_size=101M
              upload_max_filesize=100M
              xdebug.mode=debug
              [Date]
              date.timezone = 'Europe/Paris'
            '';
          };
        in
        with pkgs; [
          qemu # virtualisation

          # vscode # for liveshare

          # jdk17 # pour lancer les applis java (sonarqube nécessite 17 et pas supérieur)
          # sonar-scanner-cli # client pour lancer une analyse Sonarqube 
          # `sonar-scanner -Dsonar.projectKey=orchestra -Dsonar.sources=. -Dsonar.host.url=http://localhost:9000 -Dsonar.token=sqp_1fe82cd6a56660c387ad50cb854db99ee8093077`, après que le serveur soit lançé (`~/softs_/sonarqube-10.1.0.73491/bin/linux-x86-64/sonar.sh start` (telechargé sur  https://www.sonarqube.org/downloads/)

          # Lua (5.1 pour neovim)
          lua51Packages.lua
          lua51Packages.luarocks
          lua-language-server
          stylua # lua lsp for neovim (the version installed by lsp-installer fails to execute on nixos )

          # markdown
          marksman # markdown lsp (the version installed by mason fails to execute on nixos )
          markdownlint-cli2
          mermaid-cli # Generation of diagrams from text in a similar manner as markdown

          nodePackages.prettier

          # Scheme
          # guile_3_0

          # Node
          nodePackages.node2nix
          nodejs
          yarn

          # PHP
          # lando
          # php-env-cli # for msgpack
          php'
          php'.packages.composer
          php'.packages.php-codesniffer # CodeSniffer (beautify)
          # php'.packages.psalm # static analysis tool // fail to install on nixos 24.11
          # php'.packages.phpstan # static analysis tools // fail to install on nixos 23.11
          # Drupal coding standards installation :
          #   composer global require drupal/coder # installs phpcs as well
          #   composer global require dealerdirect/phpcodesniffer-composer-installer

          # Haskell
          # cabal-install
          # cabal2nix

          # Rust
          #   more options on https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/rust.section.md
          # rustc cargo
          rustup # then `rustup toolchain install stable; rustup default stable ; rustup component add rust-analyzer`
          binutils
          gcc
          clang
          clang-tools
          gnumake
          openssl
          pkg-config # rustup dependencies (cf. https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/rust.section.md)
          rust-analyzer-unwrapped # used by lsp in neovim
          cargo-nextest # used by neotest-rust in neovim
          lldb # debugger (used by rustaceanvim)

          # multi platform dev, can be used with rust thanks to rinf
          # flutter # needs 3Go  # Flutter, uses android-studio, chromium,...
          # android-studio

          # dev libs
          automake
          autoconf
          zlib

          # Python & co.
          (python3.withPackages (pypkgs: [
            pypkgs.pygments
            pypkgs.pylint
            pypkgs.pip
            pypkgs.pynvim # neovim integration 
          ]))

          # Databases related
          mariadb # to get the client
          sqlite
          postgresql
          # mysql-workbench # can export mcds ; very long to compile
          dbeaver-bin # mysql & posgresql, can do ssh tunneling

          # Dev tools
          atac # tui curl / postman
          xan # manipulation de .csv en ligne de commande
          #visidata # visualisation de .csv et autre en ligne de commande
          gettext # i18n
          direnv # auto set environnement when entering directories
          docker-compose
          gitAndTools.gitflow
          gitAndTools.diff-so-fancy
          jq
          jless # command line json parsers (jq : queries ; jless : explorer )
          pup # Streaming HTML processor/selector (aka jq for HTML)
          # umlDesigner # trop usine à gaz
          plantuml # draw UML diagrams from text
          graphviz # draw graphs (used by restaceanvim)
          radare2 # reverse engineering framework
          soapui # soap api testing
          universal-ctags
          sysstat # performance monitoring tools (sar...)

          # network
          openvpn
          openfortivpn

        ];

      # pour atixnet mydev
      # environment.unixODBCDrivers = with pkgs; [ unixODBCDrivers.msodbcsql17 ];

    };
in
{
  inherit flake;
}

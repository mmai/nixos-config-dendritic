{ inputs, ... }:
let
  flake.modules.homeManager.henri.imports = [
    anywhere
    linux
    communication
    media-players
  ];

  linux =
    { lib, pkgs, ... }:
    lib.mkIf (pkgs.stdenvNoCC.isLinux) {

      home.packages = [
        # ---- nix related ----------------
        pkgs.nix-index # search available packages containing files (or paths) : nix-index ; nix-locate -w libstdc++.so.6
        pkgs.nh # nix command helper

        pkgs.gparted
        pkgs.wl-clipboard
        pkgs.yazi # file tui
        pkgs.zoxide # cd
        pkgs.nix-search-cli
        pkgs.nixd # lsp
        pkgs.nixfmt-rfc-style
        pkgs.ispell
        pkgs.alacritty
      ];

      xdg.desktopEntries.nvim = {
        name = "WrappedNeovim";
        exec = "alacritty -e nvim %F";
        terminal = false;
        type = "Application";
        icon = "nvim";
        categories = [ "Utility" "TextEditor" ];
        startupNotify = false;
        mimeType = [ "text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
      };

    };

  communication =
    { lib, pkgs, ... }:
    {
      home.packages = [
        pkgs.obsidian # unfree
        pkgs.discord # unfree
        pkgs.signal-desktop
        pkgs.whatsapp-for-linux
        pkgs.zoom-us # unfree
      ];
    };

  media-players =
    { lib, pkgs, ... }:
    {
      home.packages = [
        pkgs.feishin # subsonic client ( ie to listen from funkwhale or navidrome services )
      ];
    };

  anywhere =
    { pkgs, ... }:
    let
      selfpkgs = inputs.self.packages.${pkgs.system};
    in
    {
      programs.nh.enable = true;
      programs.home-manager.enable = true;

      home.packages = [
        #inputs.nix-versions.packages.${pkgs.system}.default
        # pkgs.tree
        pkgs.bottom
        pkgs.cachix
        pkgs.jq
        pkgs.home-manager
        pkgs.television
        # selfpkgs.henri-sops-get
        # selfpkgs.henri-sops-rotate


        # ------------ Common tools
        pkgs.curl
        pkgs.wget
        # pkgs.nushell # a new shell..
        pkgs.oh-my-posh # shell prompt configurator (compatible with zsh & nushell)
        pkgs.zinit # zsh plugin manager

        # ---------- applications
        pkgs.luajit
        pkgs.fortune # displayed in neovim landpage
        pkgs.xclip # manage clipboard (needed for neovim to not freeze using xsel : https://github.com/neovim/neovim/issues/9402)

        # ------------- coding related
        pkgs.devenv
        pkgs.gitFull
        pkgs.git-filter-repo # git-filter-repo used to group '~/think' commit history by day
        pkgs.subversionClient # svn is used by zinit

        # ================ from base-terminal =====================================
        pkgs.bfg-repo-cleaner # suppression des secrets d'un repo git
        # helix # code editor
        pkgs.ueberzugpp # display images in terminal, used by yazi
        # xpdf # Viewer for PDF files, includes pdftoppm used by telescope-media-files.nvim
        pkgs.ffmpegthumbnailer # A lightweight video thumbnailer, used by yazi, telescope-media-files.nvim
        pkgs.unar # archive viewer (for yazi)
        pkgs.poppler # pdf viewer (for yazi)

        # ------------ Classic tools & alternatives
        pkgs.bat # better cat
        pkgs.tree # used by nnn
        pkgs.eza # replacement for ls with sensible defaults
        pkgs.fd # better find (and used by fzf in vim)

        # ------------ Common tools
        pkgs.imagemagick
        pkgs.ghostscript # manipulate pdfs
        pkgs.zip
        pkgs.unzip
        pkgs.mailutils # to send email from command line : `echo 'bonjour' | mail -s "my subject" "contact@something.com"`

        # ------------ Network access
        # nfs-utils  # nfs shares
        # smbclient cifs-utils # samba shares

        # ----------- Security
        pkgs.gnupg # Gnu privacy guard: used by pass/qpass, crypt emails
        pkgs.pass # password manager (needs gpg)
        pkgs.age # crypt files (better alternative than gnupg)
        pkgs.git-crypt # transparent file encryption in git

        # ---------- applications
        # amfora # gemini protocol client
        pkgs.tmux
        pkgs.tmuxp # terminal multiplexer & its session manager
        # lf # file navigator --> replaced by nnn
        pkgs.pistol # better file previewer (used by lf and fzf)
        # (nnn.override ({ withNerdIcons = true; })) # nnn file navigator with nerd icons
        pkgs.sxiv # image viewer (used by nnn)
        pkgs.yazi # nnn replacement
        pkgs.sshfs # sftp
        pkgs.surfraw # bookmarks & search engines client 
        pkgs.weechat # irc,.. client
        pkgs.zola # static website generator
        # unstable.offpunk # offline rss, gemini, ... reader (remplace newsboat)

        # -------- Cli tools
        pkgs.ansifilter # can remove ANSI terminal escape codes (colors, formatting..)
        pkgs.fzf # selection generator
        pkgs.ts # task pooler (add tasks in a queue, see the task list) 

        # -------- à essayer
        # hledger # accounting
        # dijo # habit tracker
        # figlet # creates ascii art
        # vocage # tui spaced repetition (à la Anki) -> comment installer ?

        # ----------- diagnostics
        pkgs.lsof # show open ports, etc.
        pkgs.file # Show file information. Usefull to debug 'zsh: no such file or directory' errors on binaries
        pkgs.btop
        pkgs.iotop
        pkgs.smartmontools # analyse de disque durs `smartctl /dev/sdb`
        pkgs.hdparm # `sudo hdparm -t /dev/sdb3`
        pkgs.mtr # combine ping and traceroute
        pkgs.ncdu # show disk usage
        pkgs.psmisc # contains utilities like fuser (display process IDs currently using files or sockets), etc.
        pkgs.tcpdump # to monitor network calls (in and out)

        # -------------- Automation
        pkgs.entr # run arbitrary commands when files change (example: ls *.hs | entr make build)
        pkgs.expect # A tool for automating interactive applications

        # ------------- coding related
        pkgs.lazygit
        pkgs.gitAndTools.git-annex # sync large files with git
        pkgs.gitAndTools.delta # better git diff
        pkgs.gnumake
        pkgs.just # better make 
        pkgs.tldr # Simplified and community-driven man pages
      ];
    };

in
{
  inherit flake;
}

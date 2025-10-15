{ ... }:
let
  flake.modules.nixos.leisure =
    { config, lib, pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        # rocksmithPatch.enable = true;
        # à utiliser si problème de résolution sur un jeu : `gamescope %command%` 
        gamescopeSession.enable = true;
      };
      # enhance game perfs : `gamemoderun %command%`
      # (comme gamescope, peut être indiqué dans Steam dans les paramètres de démarrage d'un jeu)
      programs.gamemode.enable = true;

      environment.systemPackages = with pkgs; [
        anki # 2.0.52
        # stellarium # planetarium (alternative: celestia which allows to move accross the universe)
        gramps # genealogy tree management

        mangohud # show stats like fps of current window : `mangohud %command%`

        calibre
        yacreader # comics viewer
        # zotero # bibliography manager
        #    stremio # popcorntime like -> pb dependence qtwebengine5

        heroic # Native GOG, Epic, and Amazon Games Launcher
        itch # itch.io games manager
        renpy # play renpy visual novel games
        # unnethack # build fails on nixos 25.05 (testé le 2025-02-09)
        crawlTiles # some roguelike games
        # superTux
        # leela-zero # go game engine (cmd = leelaz)=> additional steps : curl -O https://zero.sjeng.org/best-network && mv best-network ~/.local/share/leela-zero/

        # obs-studio # video recording and live streaming
        # libsForQt5.kdenlive mediainfo # video editing
        python312Packages.deemix # for dlmusic.sh
        picard
        chromaprint # MusicBrainz tagger (picard) with fingerprint calculator (chromaprint)

        android-file-transfer # copy files on tablet

        # system related things I will only use on my personal main computer
        # mydist.wally  # 2.1.1 ergodox keyboard firmware flashing tool
        qmk # ferris keyboard firmware flashing tool (see https://github.com/mmai/qmk_firmware/blob/master/keyboards/ferris/keymaps/mmai/readme.md)
        gcc-arm-embedded # qmk dependency
        dfu-util # qmk dependency for planck (flash )
        pkgsCross.avr.buildPackages.gcc # qmk dependency for ergodox_ez
        teensy-loader-cli # qmk dependency for ergodox_ez (flash)
      ];

      # for steam
      hardware.graphics.enable32Bit = true;
      services.pulseaudio.support32Bit = true;

      # gateway for irc 
      # services.bitlbee = {
      #   enable = true;
      #   plugins = [
      #     pkgs.bitlbee-mastodon
      #     # all plugins: `nix-env -qaP | grep bitlbee-`
      #   ];
      # };
    };
in
{
  inherit flake;
}

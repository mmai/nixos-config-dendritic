{ ... }:
let
  flake.modules.nixos.gaming =
    { config, lib, pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        # rocksmithPatch.enable = true; -> ne compile pas
        # à utiliser si problème de résolution sur un jeu : `gamescope %command%` 
        gamescopeSession.enable = true;
      };
      # enhance game perfs : `gamemoderun %command%`
      # (comme gamescope, peut être indiqué dans Steam dans les paramètres de démarrage d'un jeu)
      programs.gamemode.enable = true;

      environment.systemPackages = with pkgs; [
        mangohud # show stats like fps of current window : `mangohud %command%`

        heroic # Native GOG, Epic, and Amazon Games Launcher
        itch # itch.io games manager
        renpy # play renpy visual novel games
        # unnethack # build fails on nixos 25.05 (testé le 2025-02-09)
        crawlTiles # some roguelike games
        # superTux
        # leela-zero # go game engine (cmd = leelaz)=> additional steps : curl -O https://zero.sjeng.org/best-network && mv best-network ~/.local/share/leela-zero/
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

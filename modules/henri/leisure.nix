{ ... }:
let
  flake.modules.nixos.leisure =
    { config, lib, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        anki # 2.0.52
        # stellarium # planetarium (alternative: celestia which allows to move accross the universe)
        gramps # genealogy tree management

        calibre
        yacreader # comics viewer
        # zotero # bibliography manager
        #    stremio # popcorntime like -> pb dependence qtwebengine5

        android-file-transfer # copy files on tablet
      ];

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

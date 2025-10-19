{ ... }:
let
  flake.modules.nixos.music =
    { config, lib, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # obs-studio # video recording and live streaming
        # libsForQt5.kdenlive mediainfo # video editing
        python312Packages.deemix # for dlmusic.sh
        picard
        chromaprint # MusicBrainz tagger (picard) with fingerprint calculator (chromaprint)
      ];

    };
in
{
  inherit flake;
}

let
  flake.modules.nixos = { inherit nix-settings; };
  flake.modules.darwin = { inherit nix-settings; };

  nix-settings =
    { pkgs, config, ... }:
    {
      nix = {
        optimise.automatic = true;
        settings = {
          substituters = [
            "https://mmai.cachix.org"
            "https://devenv.cachix.org"
          ];
          trusted-public-keys = [
            "mmai.cachix.org-1:Tsm/Qy4nL22PplBmJCWhE8CorgfO4NGy+mRPF85EEeQ="
            "vix.cachix.org-1:hP/Lpdsi1dB3AxK9o6coWh+xHzvAc4ztdDYuG7lC6dI="
            "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          ];

          experimental-features = [
            "nix-command"
            "flakes"
            # "allow-import-from-derivation"
          ];
          trusted-users = [
            "root"
            "@wheel"
          ];
        };
        gc = pkgs.lib.optionalAttrs config.nix.enable {
          automatic = true;
          # interval = "weekly"; # TODO!
          options = "--delete-older-than 7d";
        };
      };
    };
in
{
  inherit flake;
}

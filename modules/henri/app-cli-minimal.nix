{ ... }:
let
  flake.modules.nixos.app-cli-minimal =
    { config, lib, pkgs, ... }:
    {
      environment.systemPackages =
        with pkgs; [
          neovim
          ripgrep # Faster than grep, ag, ..
          htop
        ];
    };
in
{
  inherit flake;
}

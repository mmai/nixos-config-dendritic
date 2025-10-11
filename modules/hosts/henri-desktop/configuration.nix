#############################################################
#
#  Henri Desktop
#  NixOS running on MSI MS-7A71 - i5-7600K x 4 - NVIDIA GeForce GTX 1070
#
###############################################################

{ inputs, ... }:
let
  flake.modules.nixos.henri-desktop.imports = with inputs.self.modules.nixos; [
    kvm-intel
    henri-desktop-unfree
    nvidia
    henri
    # xfce-desktop
  ];

  henri-desktop-unfree = inputs.self.lib.unfree-module [
    "nvidia-x11"
    "nvidia-settings"
  ];

in
{
  inherit flake;
}

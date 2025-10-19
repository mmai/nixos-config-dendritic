{ ... }:
let
  flake.modules.nixos.qmk =
    { config, lib, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # system related things I will only use on my personal main computer
        # mydist.wally  # 2.1.1 ergodox keyboard firmware flashing tool
        qmk # ferris keyboard firmware flashing tool (see https://github.com/mmai/qmk_firmware/blob/master/keyboards/ferris/keymaps/mmai/readme.md)
        gcc-arm-embedded # qmk dependency
        dfu-util # qmk dependency for planck (flash )
        pkgsCross.avr.buildPackages.gcc # qmk dependency for ergodox_ez
        teensy-loader-cli # qmk dependency for ergodox_ez (flash)
      ];
    };
in
{
  inherit flake;
}

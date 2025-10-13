{ inputs, ... }:
let
  inherit (inputs.self.lib.mk-os)
    wsl
    linux
    linux-arm
    ;

  flake.nixosConfigurations = {
    henri-desktop = linux "henri-desktop";
  };

in
{
  inherit flake;
}

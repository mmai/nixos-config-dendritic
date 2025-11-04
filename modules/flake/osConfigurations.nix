{ inputs, ... }:
let
  inherit (inputs.self.lib.mk-os)
    wsl
    linux
    linux-grub
    linux-arm
    ;

  flake.nixosConfigurations = {
    henri-desktop = linux "henri-desktop";
    henri-atixnet-laptop = linux "henri-atixnet-laptop";
    activitypub = linux-grub "activitypub";
    raspberry = linux-aarch64 "raspberry";
  };

in
{
  inherit flake;
}

{ inputs, ... }:
let
  inherit (inputs.self.lib.mk-os)
    wsl
    linux
    linux-grub
    linux-raspberry
    ;

  flake.nixosConfigurations = {
    henri-desktop = linux "henri-desktop";
    henri-atixnet-laptop = linux "henri-atixnet-laptop";
    activitypub = linux-grub "activitypub";
    raspberry = linux-raspberry "raspberry";
  };

in
{
  inherit flake;
}

{ inputs, ... }:
{
  flake.modules.nixos.nixos-extlinux.imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.self.modules.nixos.locale
    inputs.self.modules.nixos.zsh
    inputs.self.modules.nixos.bootable-extlinux
    inputs.self.modules.nixos.nix-settings
    inputs.self.modules.nixos.unfree
  ];
}

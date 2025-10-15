{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
    inputs.home-manager.flakeModules.home-manager
    # inputs.nixos-rocksmith.nixosModules.default
  ];

  flake-file.inputs = {
    devshell.url = "github:numtide/devshell";
    home-manager.url = "github:nix-community/home-manager";
    nixos-rocksmith = {
      url = "github:re1n0/nixos-rocksmith";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

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
    sops-nix.url = "github:Mic92/sops-nix";
    trictrac.url = "github:mmai/trictrac";
    nixos-rocksmith = {
      url = "github:re1n0/nixos-rocksmith";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

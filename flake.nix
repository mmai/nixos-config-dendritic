# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "Mmai's Nix Environment";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    allow-import-from-derivation = true;
    extra-substituters = [ "https://mmai.cachix.org" ];
    extra-trusted-public-keys = [
      "mmai.cachix.org-1:Tsm/Qy4nL22PplBmJCWhE8CorgfO4NGy+mRPF85EEeQ="
    ];
  };
  inputs = {
    allfollow = {
      url = "github:spikespaz/allfollow";
    };
    flake-file = {
      url = "github:vic/flake-file";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    devshell = {
      url = "github:numtide/devshell";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
    };
    import-tree = {
      # ok : ?rev=6ebb8cb87987b20264c09296166543fd3761d274
      url = "github:vic/import-tree";
    };
    nixpkgs = {
      # url = "github:nixos/nixpkgs/nixpkgs-unstable";
      # url = "github:nixos/nixpkgs/nixos-25.11";
      url = "github:nixos/nixpkgs/nixos-26.05";
    };
    nixpkgs-lib = {
      follows = "nixpkgs";
    };
    systems = {
      url = "github:nix-systems/default";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
    trictrac.url = "github:mmai/trictrac";
    nixos-rocksmith = {
      url = "github:re1n0/nixos-rocksmith";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

}

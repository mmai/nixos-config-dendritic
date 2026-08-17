{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
    inputs.home-manager.flakeModules.home-manager
  ];

  flake-file.inputs = {
    devshell.url = "github:numtide/devshell";
    home-manager.url = "github:nix-community/home-manager";
    sops-nix.url = "github:Mic92/sops-nix";
    trictrac.url = "github:mmai/trictrac";
    nixos-rocksmith = {
      # "release" branch: PipeASIO-based patch (programs.steam.rocksmithPatch),
      # cf. https://codeberg.org/nizo/linux-rocksmith/src/branch/main/guides/setup/nixos.md
      url = "github:re1n0/nixos-rocksmith/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

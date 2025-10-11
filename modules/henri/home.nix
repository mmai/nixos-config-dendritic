{ inputs, ... }:
let
  flake.homeConfigurations.henri = henri_at "henri-desktop";
  flake.homeConfigurations."henri@henri-desktop" = henri_at "henri-desktop";

  henri_at =
    host:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.self.nixosConfigurations.${host}.pkgs;
      modules = [ inputs.self.homeModules.henri ];
      extraSpecialArgs.osConfig = inputs.self.nixosConfigurations.${host}.config;
    };

  flake.homeModules.henri.imports = [
    inputs.self.modules.homeManager.henri
  ];

  flake.modules.homeManager.henri =
    { pkgs, lib, ... }:
    {
      home.username = lib.mkDefault "henri";
      home.homeDirectory = lib.mkDefault "/home/henri";
      home.stateVersion = lib.mkDefault "25.05";
    };

in
{
  inherit flake;
}

{ inputs, ... }:
let
  flake.modules.homeManager.henri.imports = [
    unfree
  ];

  unfree = inputs.self.lib.unfree-module [
    "obsidian"
    "discord"
    "zoom"
  ];
in
{
  inherit flake;
}

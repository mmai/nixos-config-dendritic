{ inputs, ... }:
let
  flake.modules.nixos.autologin =
    { config, lib, ... }:
    lib.mkIf config.services.displayManager.enable {
      services.displayManager.autoLogin.enable = true;
      services.displayManager.autoLogin.user = "henri";
    };
in
{
  inherit flake;
}

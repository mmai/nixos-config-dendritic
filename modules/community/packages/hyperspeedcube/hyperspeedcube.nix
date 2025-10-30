{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.hyperspeedcube = pkgs.callPackage ./_hyperspeedcube.nix { };
    };

}

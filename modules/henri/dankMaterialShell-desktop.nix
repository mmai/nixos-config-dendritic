{
  flake.modules.nixos.dankMaterialShell-desktop = { pkgs, ... }:
    {
      programs.niri.enable = true;
      programs.dms-shell.enable = true;
      services.displayManager.dms-greeter.compositor.name = "niri";
    };
}

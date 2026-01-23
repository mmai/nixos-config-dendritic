{
  flake.modules.nixos.dankMaterialShell-desktop = { pkgs, ... }:
    {
      programs.dms-shell.enable = true;
    };
}

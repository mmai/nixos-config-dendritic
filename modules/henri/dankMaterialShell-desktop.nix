{
  flake.modules.nixos.dankMaterialShell-desktop = { pkgs, ... }:
    {
      programs.niri.enable = true;
      programs.dms-shell.enable = true;
      services.displayManager.dms-greeter = {
        enable = true;
        compositor.name = "niri";
        # Sync your user's DankMaterialShell theme with the greeter. You'll probably want this
        # configHome = "/home/henri";
      };

      environment.systemPackages = with pkgs; [
        # used by niri to run steam & electron apps
        xwayland-satellite

        # used by DMS-ScreenCapture_Toolbar screen recorder
        slurp # Select a region in a Wayland compositor
        gpu-screen-recorder
      ];
    };
}

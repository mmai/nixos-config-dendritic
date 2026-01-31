{

  flake.modules.nixos.nvidia580 =
    { config, pkgs, lib, ... }:
    let
      nvidiaPkg = config.boot.kernelPackages.nvidiaPackages.production.overrideAttrs {
        version = "580.126.09";
        src = pkgs.fetchurl {
          url = "https://us.download.nvidia.com/XFree86/Linux-x86_64/580.126.09/NVIDIA-Linux-x86_64-580.126.09.run";
          sha256 = "4cac53e48f8adff661d47c8788ed24059a248c9fd8098ceafd088a498986ec26";
        };
      };
    in
    {
      services.xserver = {
        videoDrivers = [ "nvidia" ];
      };

      environment.sessionVariables = {
        # force GBM as a backend (instead of EGLStreams)
        # probably not needed anymore
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        # Hardware acceleration on NVIDIA GPUs
        LIBVA_DRIVER_NAME = "nvidia";

        # Controls if G-Sync capable monitors should use Variable Refresh Rate (VRR)
        __GL_GSYNC_ALLOWED = "0";
        # Controls if Adaptive Sync should be used.
        # Recommended to set as “0” to avoid having problems on some games.
        __GL_VRR_ALLOWED = "0";

        # use legacy DRM interface instead of atomic mode setting.
        # Might fix flickering issues
        WLR_DRM_NO_ATOMIC = "1";

        # fix invisible cursor with nvidia driver
        WLR_NO_HARDWARE_CURSORS = "1";

        # Hardware acceleration for Firefox ( not needed anymore ?)
        # MOZ_DISABLE_RDD_SANDBOX = "1";
      };

      environment.systemPackages = with pkgs; [
        mesa-demos
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools
      ];

      hardware = {
        nvidia-container-toolkit.enable = true;
        nvidia = {
          package = nvidiaPkg;
          open = false; # x fails with : nvidia card does not support 'open'
          modesetting.enable = true;
          nvidiaSettings = false;
          powerManagement.enable = true; # fix suspend resume issues
        };

        graphics = {
          extraPackages = with pkgs; [ nvidia-vaapi-driver ];
        };
      };
    };
}

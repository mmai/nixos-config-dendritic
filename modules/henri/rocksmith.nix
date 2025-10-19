{ ... }:
let
  flake.modules.nixos.rocksmith =
    { config, lib, pkgs, ... }:
    {
      services.pipewire = {
        enable = true;
        jack.enable = true;
      };

      ### Audio Extra 
      security.rtkit.enable = true; # Enables rtkit (https://directory.fsf.org/wiki/RealtimeKit)

      #
      # domain = "@audio": This specifies that the limits apply to users in the @audio group.
      # item = "memlock": Controls the amount of memory that can be locked into RAM.
      # value (`unlimited`) allows members of the @audio group to lock as much memory as needed. This is crucial for audio processing to avoid swapping and ensure low latency.
      #
      # item = "rtprio": Controls the real-time priority that can be assigned to processes.
      # value (`99`) is the highest real-time priority level. This setting allows audio applications to run with real-time scheduling, reducing latency and ensuring smoother performance.
      #
      security.pam.loginLimits = [
        { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
        { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
      ];

      # Add user to `audio` and `rtkit` groups.
      # users.users.<username>.extraGroups = [ "audio" "rtkit" ];

      environment.systemPackages = with pkgs; [
        qpwgraph # Lets you view pipewire graph and connect IOs
        pavucontrol # Lets you disable inputs/outputs, can help if game auto-connects to bad IOs
        unzip # Used by patch-nixos.sh
        rtaudio
      ];

      ### Steam (https://nixos.wiki/wiki/Steam)
      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          extraLibraries = pkgs': with pkgs'; [ pkgsi686Linux.pipewire.jack ]; # Adds pipewire jack (32-bit)
          extraPkgs = pkgs': with pkgs'; [ wineasio ]; # Adds wineasio
        };
      };

    };
in
{
  inherit flake;
}

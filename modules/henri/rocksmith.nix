{ ... }:
let
  flake.modules.nixos.rocksmith =
    { lib, pkgs, ... }:
    {
      # PipeASIO-based patch from inputs.nixos-rocksmith (release branch).
      # Handles pipewire/rtkit/pam setup, patches the game with RS_ASIO on every
      # `home-manager` activation (auto-detects the Steam library, so it keeps
      # working even with Rocksmith installed on the LexarExt4 drive), and
      # installs a `launch-rocksmith` wrapper via home-manager.
      #
      # One-time manual step: in Steam, set Rocksmith 2014's launch options to
      # `launch-rocksmith %command%`.
      #
      # Without explicit devices, PipeASIO falls back to the system default
      # source (the webcam mic here, not the guitar) and can feedback-loop into
      # the default sink. Pin it to the actual Rocksmith Real Tone cable and to
      # the speakers (`wpctl status` / `pw-dump` to list node names if this
      # hardware changes).
      programs.steam.rocksmithPatch = {
        enable = true;
        pipeasio = {
          inputDevice = "alsa_input.usb-Hercules_Rocksmith_USB_Guitar_Adapter-00.mono-fallback";
          outputDevice = "alsa_output.pci-0000_00_1f.3.analog-surround-21";
        };
      };

      # `wpctl` (wireplumber) and `pw-cli`/`pw-dump` (pipewire) are already
      # available system-wide; add pactl (its device names match what
      # pipeasio's config.ini above expects) and GUI tools for routing/mixing.
      environment.systemPackages = with pkgs; [
        pulseaudio # for `pactl`
        crosspipe # pipewire patchbay, cf. linux-rocksmith guide
        pavucontrol
      ];

      # patchRocksmith's `pipeasio-register` initializes a Wine prefix (32- and
      # 64-bit ASIO driver registration), which can take a while. Home-manager
      # already gives the service a 5m start timeout, but restarting an
      # already-running instance (e.g. rebuilding again while it's still
      # patching) hit the default *stop* timeout instead, killing it mid-way
      # and failing the rebuild.
      systemd.services.home-manager-henri.serviceConfig.TimeoutStopSec = "300s";

      home-manager.users.henri =
        { lib, pkgs, ... }:
        {
          # Upstream's `get-steam-app-path` (used by the patch-rocksmith activation
          # script) defaults to the XDG `~/.local/share/Steam` root and hard-fails
          # (killing the whole home-manager activation, and thus every
          # `nixos-rebuild switch`) when it can't find Rocksmith there. This
          # install actually lives under `~/.steam/steam` (classic layout), and
          # the patch should never be allowed to block an unrelated rebuild (e.g.
          # if the drive is briefly unplugged), so point it at the right root and
          # make it best-effort.
          home.activation.patchRocksmith = lib.mkForce (
            lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              STEAM_ROOT="$HOME/.steam/steam" ${lib.getExe pkgs.patch-rocksmith} || true
            ''
          );
        };
    };
in
{
  inherit flake;
}

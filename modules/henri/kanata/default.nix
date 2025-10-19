{
  flake.modules.nixos.kanata = { pkgs, ... }:
    {
      # keyboard remapping
      services.kanata =
        let arsenikDefCfg = "
    ;; Enabled makes kanata process keys that are not defined in defsrc
    ;; Fixes altgr for Windows (see Arsenik issue #22)
    process-unmapped-keys yes
    windows-altgr cancel-lctl-press
    ";
        in
        {
          enable = true;

          keyboards = {
            thinkpad = {
              devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
              # config = builtins.readFile (./kanata.kbd);
              config = import ./kanata_arsenik.nix;
              extraDefCfg = arsenikDefCfg;
            };
            msCurve = {
              devices = [ "/dev/input/by-id/usb-Microsoft_Comfort_Curve_Keyboard_2000-event-kbd" ];
              config = import ./kanata_arsenik.nix;
              extraDefCfg = arsenikDefCfg;
            };
          };
        };
    };
}

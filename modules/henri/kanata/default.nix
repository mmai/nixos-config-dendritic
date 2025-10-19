{
  flake.modules.nixos.kanata = { pkgs, ... }:
    {
      # keyboard remapping
      services.kanata =
        let
          arsenikDefCfg = "
    ;; Enabled makes kanata process keys that are not defined in defsrc
    ;; Fixes altgr for Windows (see Arsenik issue #22)
    process-unmapped-keys yes
    windows-altgr cancel-lctl-press
    ";
          kanataKbd = "
;; Simple copy of the ./arsenik/kanata.kbd file (from https://github.com/OneDeadKey/arsenik/releases),
;; with 'includes' replaced by nix readFile
;; and defCfg removed (its content must be copied in the field of the same name in default.nix )
;;==========================================================================;;
;;                                                                          ;;
;;  With Arsenik, choose the features you want for your keyboard:           ;;
;;  angle mods, Vim-like navigation layer, Mac/Azerty/Qwertz support, etc.  ;;
;;                                                                          ;;
;;==========================================================================;;

;; Every section is mandatory and should enable one and only one `include`
;; - enable each feature by un-commenting the related line.
;; - a commented line starts with ;;

;; Live-reload the configuration with Space+Backspace (requires layer-taps).

;; Timing variables for tap-hold effects.
(defvar
  ;; The key must be pressed twice in 200ms to enable repetitions.
  tap_timeout 200
  ;; The key must be held 200ms to become a layer shift.
  hold_timeout 200
  ;; Slightly higher value for typing keys, to prevent unexpected hold effect.
  long_hold_timeout 300
)

;;-----------------------------------------------------------------------------
;; Original key arrangement on your keyboard: Mac or PC.
;; Choose here if you want to add an angle mod: ZXCVB are shifted to the left.
;; See https://colemakmods.github.io/ergonomic-mods/angle.html for more details.

;; (include defsrc/pc.kbd)  ;; PC, standard finger assignment
;; (include defsrc/mac.kbd)  ;; Mac, standard finger assignment
;; (include defsrc/pc_anglemod.kbd)  ;; PC, ZXCVB are shifted to the left
" + builtins.readFile (./arsenik/defsrc/pc_anglemod.kbd) + "
;; (include defsrc/mac_anglemod.kbd)  ;; Mac, ZXCVB are shifted to the left
;; (include defsrc/pc_wide_anglemod.kbd)  ;; PC, angle-mod + right hand shifted by one key
;; (include defsrc/mac_wide_anglemod.kbd)  ;; Mac, angle-mod + right hand shifted by one key


;;-----------------------------------------------------------------------------
;; `Base` layer: standard or dual keys? (layer-taps, homerow mods?)
;; If you just want angle mod, you still have to enable the standard base.

;; (include deflayer/base.kbd)  ;; standard keyboard behavior
;; (include deflayer/base_lt.kbd)  ;; layer-taps on both thumb keys
;; (include deflayer/base_lt_hrm.kbd)  ;; layer-taps + home-row mods
" + builtins.readFile (./arsenik/deflayer/base_lt_hrm.kbd) + "

            ;; Note: not enabling layer-taps here makes the rest of the file useless.


            ;;-----------------------------------------------------------------------------
            ;; `Symbols` layer

            ;; (include deflayer/symbols_noop.kbd)  ;; AltGr stays as-is
            ;; (include deflayer/symbols_lafayette.kbd)  ;; AltGr programmation layer like Ergo‑L
            ;; (include deflayer/symbols_noop_num.kbd)  ;; AltGr stays as-is + NumRow layers
            ;; (include deflayer/symbols_lafayette_num.kbd)  ;; AltGr prog layer + NumRow layers
            " + builtins.readFile (./arsenik/deflayer/symbols_lafayette_num.kbd) + "

            ;;-----------------------------------------------------------------------------
            ;; `Navigation` layer: ESDF or HJKL?

            ;; (include deflayer/navigation.kbd)  ;; ESDF on the left, NumPad on the right
            ;; (include deflayer/navigation_vim.kbd)  ;; HJKL + NumPad on [Space]+[Q]
            " + builtins.readFile (./arsenik/deflayer/navigation_vim.kbd) + "

            ;; Replace XX by the keyboard shortcut of your application launcher, if any.
            ;; Mapped on [Space]+[P] in both navigation layers.

            ;; (defalias run M-p)  ;; [Command]-[P]
            (defalias run XX)  ;; do nothing


            ;;-----------------------------------------------------------------------------
            ;; Aliases for `Symbols` and `Navigation` layers
            ;; Depends on PC/Mac and keyboard layout

            ;; (include defalias/ergol_pc.kbd)  ;; Ergo‑L PC
            ;; (include defalias/qwerty-lafayette_pc.kbd)  ;; Qwerty‑Lafayette PC
            ;; (include defalias/qwerty_pc.kbd)  ;; Qwerty / Colemak PC
            " + builtins.readFile (./arsenik/defalias/qwerty_pc.kbd) + "
;; (include defalias/qwerty_mac.kbd)  ;; Qwerty / Colemak Mac
;; (include defalias/azerty_pc.kbd)  ;; Azerty PC
;; (include defalias/qwertz_pc.kbd)  ;; Qwertz PC
;; (include defalias/bepo_pc.kbd)  ;; Bépo PC
;; (include defalias/optimot_pc.kbd)  ;; Optimot PC

;;-----------------------------------------------------------------------------
;; Extra configuration
;; You should not modify this, only if you need to.

;;  (defcfg
    ;; Enabled makes kanata process keys that are not defined in defsrc
    ;; Fixes altgr for Windows (see Arsenik issue #22)
 ;;   process-unmapped-keys yes
 ;;  windows-altgr cancel-lctl-press
 ;; )

  ;; vim: set ft=lisp
  ";
        in
        {
          enable = true;

          keyboards = {
            thinkpad = {
              devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
              # config = builtins.readFile (./kanata.kbd);
              config = kanataKbd;
              extraDefCfg = arsenikDefCfg;
            };
            msCurve = {
              devices = [ "/dev/input/by-id/usb-Microsoft_Comfort_Curve_Keyboard_2000-event-kbd" ];
              config = kanataKbd;
              extraDefCfg = arsenikDefCfg;
            };
          };
        };
    };
}

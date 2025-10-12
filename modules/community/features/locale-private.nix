{ lib, pkgs, ... }:
{
  flake.modules.nixos.locale =
    { modulesPath, ... }:
    {
      time.timeZone = lib.mkDefault "Europe/Paris";

      i18n = {
        defaultLocale = lib.mkDefault "fr_FR.UTF-8";
        supportedLocales = [ "fr_FR.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
      };

      # Chinese input
      i18n.inputMethod = {
        type = "ibus";
        enable = true;
        # enabled = "ibus";
        ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
      };

      services.xserver.xkb = {
        layout = "us,fr";
        variant = "intl,"; # US, intl., with dead keys
        options = "compose:menu, grp:shifts_toggle"; # switch keyboard layout with both shift keys pressed 
      };
      console.useXkbConfig = true; # Console use same keyboard config as xserver
    };
}

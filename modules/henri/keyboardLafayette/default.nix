{
  flake.modules.nixos.keyboardLafayette = { pkgs, config, ... }:
{
  services.xserver.xkb.extraLayouts = {
    lafayette = {
      description = "French (Qwerty-Lafayette)";
      # copié de https://qwerty-lafayette.org/releases/lafayette_linux_v0.9.xkb_custom
      symbolsFile = symbols/lafayette_linux_v0.9.xkb_custom;
      languages = [ "fr" ];
    };
    # ergol = {
    #   description = "French (Ergo-L)";
    #   # copié de https://github.com/Nuclear-Squid/ergol/releases/download/ergol-v1.0.0/ergol.xkb_symbols
    #   symbolsFile = symbols/ergol.xkb_symbols;
    #   languages = [ "fr" ];
    # };
  };

};
}

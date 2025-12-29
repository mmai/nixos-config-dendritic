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
  };

};
}

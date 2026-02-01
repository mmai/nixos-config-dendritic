{
  flake.modules.nixos.keyboardLafayette = { pkgs, config, lib, ... }:
    {
      services.xserver.xkb.extraLayouts = {
        lafayette = {
          description = "French (Qwerty-Lafayette)";
          # copié de https://qwerty-lafayette.org/releases/lafayette_linux_v0.9.xkb_custom
          symbolsFile = symbols/lafayette_linux_v0.9.xkb_custom;
          languages = [ "fr" ];
        };
      };
      # export configuration so that commands like `localectl list-keymaps` works
      # we have to use "lib.mkForce" because of https://github.com/NixOS/nixpkgs/issues/254523#issuecomment-1723038356
      services.xserver.exportConfiguration = lib.mkForce true;

    };
}

{ inputs, ... }:
let
  flake.modules.nixos.henri.imports = [
    user
    linux
    autologin
    home
  ];

  home.home-manager.users.henri.imports = [
    inputs.self.homeModules.henri
  ];

  autologin =
    { config, lib, ... }:
    lib.mkIf config.services.displayManager.enable {
      services.displayManager.autoLogin.enable = true;
      services.displayManager.autoLogin.user = "henri";
    };

  linux = {
    users.users.henri = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "video"
        "plugdev"
        "input"
        "docker"
        "network"
      ];
    };

    packages = [ pkgs.home-manager pkgs.qmk pkgs.gcc-arm-embedded pkgs.dfu-util ];
  };

  user =
    { pkgs, ... }:
    {
      # home-manager.backupFileExtension = "backup";

      fonts.packages = with pkgs.nerd-fonts; [
        victor-mono
        jetbrains-mono
        inconsolata
      ];

      users.users.henri = {
        description = "henri";
        shell = pkgs.zsh;
      };
    };
in
{
  inherit flake;
}

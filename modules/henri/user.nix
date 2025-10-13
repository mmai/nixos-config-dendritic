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

    # packages = [ pkgs.home-manager pkgs.qmk pkgs.gcc-arm-embedded pkgs.dfu-util ];
  };

  user =
    { pkgs, ... }:
    {
      # home-manager.backupFileExtension = "backup";

      #FONTS
      #  nerdfonts for dev symbols in text editors
      #  noto-fonts-cjk for chinese characters
      fonts = {
        # permet de lister les fonts dans /nix/var/nix/profiles/system/sw/share/X11/fonts : 
        # cd /nix/var/nix/profiles/system/sw/share/X11/fonts
        # fc-query MesloLGSNerdFontMono-Regular.ttf | grep 'family:'
        fontDir.enable = true;

        packages = with pkgs; [
          victor-mono
          dejavu_fonts
          meslo-lgs-nf
          fantasque-sans-mono # `a tester
          powerline-fonts
          nerd-fonts.dejavu-sans-mono
          nerd-fonts.victor-mono
          noto-fonts
          noto-fonts-extra
          noto-fonts-cjk-sans
          noto-fonts-emoji
        ];

        fontconfig.defaultFonts = {
          # monospace = [ "DejaVuSansMono Nerd Font" ];
          monospace = [ "MesloLGS Nerd Font Mono" ]; # font recommended by powerlevel10k zsh prompt. 
        };
      };

      programs.zsh.enable = true;

      users.users.henri = {
        description = "henri";
      };
    };
in
{
  inherit flake;
}

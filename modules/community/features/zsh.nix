{
  flake.modules.nixos.zsh =
    { pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        promptInit = ""; # disable default (use zplug system with pure prompt instead)
        interactiveShellInit = ''
          source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
        '';
      };
    };
}

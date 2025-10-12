{

  flake.modules.nixos.printing =
    { pkgs, ... }:

    {
      hardware.sane.enable = true; # Scanner
      services.printing.enable = true;
      services.printing.drivers = [ pkgs.gutenprint pkgs.epson-escpr ]; # Generic, Epson XP-225
    };
}

update:
  nix flake update
rebuild:
  sudo nix run path:.#os-rebuild -- $(hostname) switch

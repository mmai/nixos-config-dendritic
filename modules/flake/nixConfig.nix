{

  flake-file = {
    description = "Mmaai's Nix Environment";

    nixConfig = {
      allow-import-from-derivation = true;
      extra-trusted-public-keys = [
        "mmai.cachix.org-1:Tsm/Qy4nL22PplBmJCWhE8CorgfO4NGy+mRPF85EEeQ="
      ];
      extra-substituters = [ "https://mmai.cachix.org" ];
    };
  };

}

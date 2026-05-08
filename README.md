# Mmai's Nix Environment

This repository is mmai's NixOS configuration, adapted from <https://github.com/vic/vix>

## Secrets

age keys and rules in _.sops.yaml_

edit secrets with `nix run nixpkgs#sops modules/hosts/raspberry/_secrets/secrets.yaml`

## TODO

- cachix extras : add yazi, python, cuda (?)

## Troubleshooting

### How to know which package reference a broken/insecure one ?

exemple : build fails with

```sh
error: Package ‘python3.12-ecdsa-0.19.1’ in /nix/store/0fss98zylksrdnrqsws3ml39y5lwzvxj-source/pkgs/development/python-modules/ecdsa/default.nix:43 is marked as insecure, refusing to evaluate.
```

1. search package file in store : `ls /nix/store/*py*ecdsa*`
2. search referrers of the found file : `nix-store --query --referrers /nix/store/xdmqqgzz5yvaijskwqsdl8fqxgzbimgc-python3.12-ecdsa-0.19.1.drv`

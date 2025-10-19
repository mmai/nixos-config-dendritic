#!/usr/bin/env bash
set -e

# echo " > nix-collect-garbage -d"
# nix-collect-garbage -d

KEEP=1
# KEEP=2

echo " > Remove old kernels from /boot/EFI/nixos/"

# Récupérer les générations actives
active_generations=($(sudo ls -dr /nix/var/nix/profiles/system-[0-9]*-link | head -n $KEEP))
echo "Générations conservées : ${active_generations[*]}"

# Trouver les initrd utilisés par les générations actives
active_initrds=()
for gen in "${active_generations[@]}"; do
  # initrd=$(ls -l "$gen"/kernel-initrd* 2>/dev/null | awk '{print $NF}' | xargs basename)
  initrd=$(ls -l /nix/var/nix/profiles/system/initrd 2>/dev/null | awk -F'/' '{print $(NF - 1)"-initrd.efi"}')
  active_initrds+=($initrd)
done
echo "initrd utilisés : ${active_initrds[*]}"

# Lister les fichiers initrd dans /boot/EFI/nixos/
boot_dir="/boot/EFI/nixos"
initrds=($(ls "$boot_dir"/*-initrd-linux-*.efi 2>/dev/null | xargs -n1 basename))

# Trouver les fichiers initrd non utilisés et les supprimer
for file in "${initrds[@]}"; do
  if [[ ! " ${active_initrds[@]} " =~ " $file " ]]; then
    echo "Suppression de : $boot_dir/$file"
    sudo rm "$boot_dir/$file"
  else
    echo "Conservation de : $file"
  fi
done

echo " > Delete old nixos generations"
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +$KEEP

echo " > Rebuild system"
# sudo nixos-rebuild switch

# en dernier recours :
# sudo mv /boot/EFI/Microsoft ~/backup_boot_Microsoft/
# sudo nixos-rebuild switch
# just free-boot-space
# sudo mv ~/backup_boot_Microsoft/ /boot/EFI/Microsoft

update:
  nix flake update
rebuild:
  sudo nix run path:.#os-rebuild -- $(hostname) switch
[group('deploy')]
raspberry-fetch:
  ssh rasp.rhumbs.fr "systemctl show trictrac-server -p ExecStart -p ExecStartPre --value" | grep -oP '/nix/store/[a-z0-9]{32}-[^ /\"]+' | sort -u | xargs -I{} nix copy --from ssh://rasp.rhumbs.fr:2822 --no-check-sigs {}

[group('deploy')]
raspberry:
  just raspberry-fetch
  nixos-rebuild switch --flake .#raspberry --target-host rasp.rhumbs.fr --sudo

music_server := 'root@raspberry'
music_local_path := '/mnt/diskstation/music/_sorted/'
music_exclude_file := '/mnt/diskstation/music/_sorted/exclude.txt'
[group('music')]
music-import:
	rsync -av --keep-dirlinks --prune-empty-dirs --exclude-from={{music_exclude_file}} {{music_local_path}} {{music_server}}:/media/music/

activitypub_server := 'root@music.rhumbs.fr'
activitypub_os_path := '/etc/nixos-dendritic'
[group('activitypub')]
[group('deploy')]
activitypub-deploy:
	rsync -azv ./ {{activitypub_server}}:{{activitypub_os_path}}
	ssh {{activitypub_server}} -t "nix run path:{{activitypub_os_path}}#os-rebuild -- activitypub switch"

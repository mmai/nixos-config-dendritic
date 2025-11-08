update:
  nix flake update
rebuild:
  sudo nix run path:.#os-rebuild -- $(hostname) switch
raspberry:
  nixos-rebuild switch --flake .#raspberry --target-host raspberry
  # nixos-rebuild switch --flake .#raspberry --target-host raspberry --sudo --ask-sudo-password

activitypub_server := 'root@music.rhumbs.fr'
activitypub_local_music_path := '/mnt/diskstation/music/_sorted/'
activitypub_exclude_file := '/mnt/diskstation/music/_sorted/exclude.txt'
activitypub_os_path := '/etc/nixos-dendritic'
[group('activitypub')]
music-import:
	rsync -av --keep-dirlinks --prune-empty-dirs --exclude-from={{activitypub_exclude_file}} {{activitypub_local_music_path}} {{activitypub_server}}:/media/music/
[group('activitypub')]
[group('deploy')]
music-deploy:
	rsync -azv ./ {{activitypub_server}}:{{activitypub_os_path}}
	ssh {{activitypub_server}} -t "nix run path:{{activitypub_os_path}}#os-rebuild -- activitypub switch"

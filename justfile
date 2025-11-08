update:
  nix flake update
rebuild:
  sudo nix run path:.#os-rebuild -- $(hostname) switch
[group('deploy')]
raspberry:
  nixos-rebuild switch --flake .#raspberry --target-host raspberry --sudo
  # nixos-rebuild switch --flake .#raspberry --target-host raspberry --sudo --ask-sudo-password

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

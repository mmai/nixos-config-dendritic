{ ... }:
let
  flake.modules.nixos.sync-notes =
    { config, lib, pkgs, ... }:
    {
      systemd.user.timers.sync-notes = {
        description = "run sync-notes every 15 minutes";
        wantedBy = [ "timers.target" ]; # enable it & auto start it
        timerConfig = {
          OnBootSec = "1m"; # first run 1min after boot up
          OnUnitInactiveSec = "15m"; # run 15min after sync-notes has finished
        };
      };

      # Configure ~/think directory to allow synchronization with: 
      # `git config --bool branch.master.sync true`
      # `git config --bool branch.master.syncNewFiles true`
      systemd.user.services.sync-notes = {
        description = "Synchronize wiki and todo files with git-sync";
        script = "cd ~/think && ${pkgs.gitAndTools.git-sync}/bin/git-sync";
        path = [ pkgs.openssh ]; # path to dependencies 
        serviceConfig.Type = "oneshot";
      };

    };
in
{
  inherit flake;
}

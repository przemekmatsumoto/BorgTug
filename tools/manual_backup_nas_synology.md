1. Nas synology 1 with password passed to the Borg repository on the client
ssh -R /tmp/nas-synology1.sock:/run/remote-backup/nas-synology1.sock -t nas_synology1 "sudo -E BORG_PASSCOMMAND='/opt/bin/pass show repozytoria/borg/nas_synology'  /opt/bin/borg --rsh=\"sh -c 'exec /opt/bin/socat STDIO UNIX-CONNECT:/tmp/nas-synology1.sock'\" create --progress ssh://dummy/mnt/backup/nas_synology_one::backup-{now:%Y-%m-%d-%H-%M} /root"

2. Nas synology 1 with password passed to the Borg repository on the backup server
ssh -R /tmp/nas-synology1.sock:/run/remote-backup/nas-synology1.sock -t nas_synology1 "sudo BORG_PASSPHRASE=\"$(pass show repozytoria/borg/nas_synology)\"  /opt/bin/borg --rsh=\"sh -c 'exec /opt/bin/socat STDIO UNIX-CONNECT:/tmp/nas-synology1.sock'\" create --progress ssh://dummy/mnt/backup/nas_synology_one::backup-{now:%Y-%m-%d-%H-%M} /volume1/nie_wiem/test_backup"

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Of course, you also have the `backup@.service` configured on the server, which you can manually trigger using:  
sudo systemctl restart backup@CLIENT_NAME.service
Example:  
sudo systemctl restart backup@client2.service
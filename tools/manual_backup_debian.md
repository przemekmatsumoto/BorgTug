3. Server 2 with password passed to the Borg repository on the client
ssh -R /tmp/ubuntu2.sock:/run/remote-backup/ubuntu2.sock -t ubuntu2 "sudo -E BORG_PASSCOMMAND='pass show repozytoria/borg/ubuntu2' borg --rsh=\"sh -c 'exec socat STDIO UNIX-CONNECT:/tmp/ubuntu2.sock'\" create --progress ssh://dummy/mnt/backup/ubuntu_two::backup-{now:%Y-%m-%d-%H-%M} /home/borg/test_backup_catalogue /home/borg/test_backup_catalogue1"

4. Server 2 with password passed to the Borg repository on the backup server  
ssh -R /tmp/ubuntu2.sock:/run/remote-backup/ubuntu2.sock -t ubuntu2 "sudo BORG_PASSPHRASE=\"$(pass show repozytoria/borg/ubuntu2)\" borg --rsh=\"sh -c 'exec socat STDIO UNIX-CONNECT:/tmp/ubuntu2.sock'\" create --progress ssh://dummy/mnt/backup/ubuntu_two::backup-{now:%Y-%m-%d-%H-%M} /home/borg/test_backup_catalogue /home/borg/test_backup_catalogue1"


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Of course, you also have the `backup@.service` configured on the server, which you can manually trigger using:  
sudo systemctl restart backup@CLIENT_NAME.service
Example:  
sudo systemctl restart backup@client2.service
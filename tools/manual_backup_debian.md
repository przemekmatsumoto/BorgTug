### Manual backup test

1. As remote-backup user:
    ```bash
    ssh -R /tmp/ubuntu2.sock:/path/where/the/sock/will/be/created/on/your/backup/server -t your_ssh_client_from_.ssh_config_file "sudo -E BORG_PASSCOMMAND='pass show /path/to/your/pass/password/for/borgbackup/repo' borg --rsh=\"sh -c 'exec socat STDIO UNIX-CONNECT:/tmp/ubuntu2.sock'\" create --progress ssh://dummy/path/to/your/borg/repository::backup-{now:%Y-%m-%d-%H-%M} /your/directories/to/be/backupd/from/the/client"
    ```

    ⚠️ Don't forget to change:
    - `/path/where/the/sock/will/be/created/on/your/backup/server`
    - `your_ssh_client_from_.ssh_config_file`
    - `/path/to/your/pass/password/for/borgbackup/repo`
    - `path/to/your/borg/repository`
    - `/your/directories/to/be/backupd/from/the/client`


#### Example:
```bash
ssh -R /tmp/ubuntu2.sock:/run/remote-backup/ubuntu2.sock -t ubuntu2 "sudo -E BORG_PASSCOMMAND='pass show repozytoria/borg/ubuntu2' borg --rsh="sh -c 'exec socat STDIO UNIX-CONNECT:/tmp/ubuntu2.sock'" create --progress ssh://dummy/mnt/backup/ubuntu_two::backup-{now:%Y-%m-%d-%H-%M} /home/borg/test_backup_catalogue /home/borg/test_backup_catalogue1"
```

---

### **Also you can use `run_backup.sh` script in your `/home/remote-backup/backup` catalogue on the server**
```bash
./run_backup.sh CLIENT_NAME
```

#### Example:
```bash
./run_backup.sh debian1
```
**⚠️ To run that script you have to be in `/home/remote-backup/backup` catalogue!**

---

### **Of course, you also have the `backup@.service` configured on the server, which you can manually trigger using:**
```bash
sudo systemctl restart backup@CLIENT_NAME.service
```

#### Example:  
```bash
sudo systemctl restart backup@client2.service
```

---




<!-- 
Server 2 with password passed to the Borg repository on the backup server  
ssh -R /tmp/ubuntu2.sock:/run/remote-backup/ubuntu2.sock -t ubuntu2 "sudo BORG_PASSPHRASE=\"$(pass show repositories/borg/debian1)\" borg --rsh=\"sh -c 'exec socat STDIO UNIX-CONNECT:/tmp/ubuntu2.sock'\" create --progress ssh://dummy/mnt/backup/ubuntu_two::backup-{now:%Y-%m-%d-%H-%M} /home/borg/test_backup_catalogue /home/borg/test_backup_catalogue1" -->

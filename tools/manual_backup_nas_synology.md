### Manual backup test

1. As remote-backup user:
    ```bash
    ssh -R /tmp/nas-synology1.sock:/path/where/the/sock/will/be/created/on/your/backup/server -t your_ssh_client_from_.ssh_config_file "sudo -E BORG_PASSCOMMAND='/opt/bin/pass show /path/to/your/pass/password/for/borgbackup/repo'  /opt/bin/borg --rsh=\"sh -c 'exec /opt/bin/socat STDIO UNIX-CONNECT:/tmp/nas-synology1.sock'\" create --progress ssh://dummy/path/to/your/borg/repository::backup-{now:%Y-%m-%d-%H-%M} /your/directories/to/be/backupd/from/the/client"
    ```

    ⚠️ Don't forget to change:
    - `/path/where/the/sock/will/be/created/on/your/backup/server`
    - `your_ssh_client_from_.ssh_config_file`
    - `/path/to/your/pass/password/for/borgbackup/repo`
    - `path/to/your/borg/repository`
    - `/your/directories/to/be/backupd/from/the/client`

#### Example:
```bash
    ssh -R /tmp/nas-synology1.sock:/run/remote-backup/nas-synology1.sock -t nas_synology1 "sudo -E BORG_PASSCOMMAND='/opt/bin/pass show repozytoria/borg/nas_synology'  /opt/bin/borg --rsh=\"sh -c 'exec /opt/bin/socat STDIO UNIX-CONNECT:/tmp/nas-synology1.sock'\" create --progress ssh://dummy/mnt/backup/nas_synology_one::backup-{now:%Y-%m-%d-%H-%M} /root"
```

---

### **Also you can use `run_backup.sh` script in your `/home/remote-backup/backup` catalogue on the server**
```bash
./run_backup.sh CLIENT_NAME
```

#### Example:
```bash
./run_backup.sh nas1
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








<!-- 2. Nas synology 1 with password passed to the Borg repository on the backup server
ssh -R /tmp/nas-synology1.sock:/run/remote-backup/nas-synology1.sock -t nas_synology1 "sudo BORG_PASSPHRASE=\"$(pass show repozytoria/borg/nas_synology)\"  /opt/bin/borg --rsh=\"sh -c 'exec /opt/bin/socat STDIO UNIX-CONNECT:/tmp/nas-synology1.sock'\" create --progress ssh://dummy/mnt/backup/nas_synology_one::backup-{now:%Y-%m-%d-%H-%M} /volume1/nie_wiem/test_backup" -->

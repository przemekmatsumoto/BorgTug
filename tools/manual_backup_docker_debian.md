### Manual backup test

1. As remote-backup user:
    ```bash
    ssh -tt -o BatchMode=yes -R 'tmp/nas1.sock:/path/where/the/sock/will/be/created/on/your/backup/serwer' your_ssh_client_from_.ssh_config_file "sudo -E /usr/local/bin/docker run --rm -e BORG_PASSCOMMAND='pass show /path/to/your/pass/password/for/borgbackup/repo' -v /your/catalogue/to/be/mounted/in/the/container:/data:ro -v /tmp:/tmp:rw --user root nas borg --rsh=\"sh -c 'exec socat STDIO UNIX-CONNECT:/tmp/nas1.sock'\" create --progress ssh://dummy/path/to/your/borg/repository::backup-$(date '+%Y-%m-%d_%H:%M') /your/directories/to/be/backed/up/from/the/client"
    ```

    ⚠️ Don't forget to change:
    - `/path/where/the/sock/will/be/created/on/your/backup/server`
    - `/path/to/your/pass/password/for/borgbackup/repo`
    - `path/to/your/borg/repository`
    - `/your/catalogue/to/be/mounted/in/the/container`
    - `your_ssh_client_from_.ssh_config_file`
    - `/your/directories/to/be/backed/up/from/the/client`

#### Example:
```bash
ssh -tt -o BatchMode=yes -R 'tmp/debian1.sock:/run/remote-backup/debian1.sock' debian1 "sudo -E docker run --rm -e BORG_PASSCOMMAND='pass show repositories/borg/debian' -v /home:/data:ro -v /tmp:/tmp:rw --user root debian borg --rsh=\"sh -c 'exec socat STDIO UNIX-CONNECT:/tmp/debian1.sock'\" create --progress ssh://dummy/mnt/backup/debian1::backup-$(date '+%Y-%m-%d_%H:%M') /data/borg/test"
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

## 📁 debian_server.md

### SECTION 1 — Creating the `remote-backup` user

1. Add `remote-backup` user:
   ```bash
   sudo adduser remote-backup
   ```

---

### SECTION 2 — Generate SSH key and create config file as `remote-backup` user

1. Switch to the `remote-backup` user:
   ```bash
   su remote-backup
   ```

2. Create the `.ssh` directory and set permissions:
   ```bash
   mkdir -p ~/.ssh && chmod 700 ~/.ssh
   ```

3. Generate SSH key *(change `your_name_for_key`)*:
   ```bash
   ssh-keygen -t ed25519 -f /home/remote-backup/.ssh/your_name_for_key -N ""
   ```

---

### SECTION 2.1 — Copy SSH key and configure client access

1. Copy the SSH public key *(change `your_name_for_key`)*:
   ```bash
   cat /home/remote-backup/.ssh/your_name_for_key.pub
   ```

2. Create config file:
   ```bash
   touch /home/remote-backup/.ssh/config
   ```

3. Add configuration depending on number of clients (see example → `server/host/home/.ssh/config`)

---

### SECTION 3 — Install `borgbackup` and `socat`

1. Update repositories:
   ```bash
   sudo apt update
   ```

2. Install `borgbackup` and `socat`:
   ```bash
   sudo apt install borgbackup socat
   ```

---

### SECTION 4 — Create borgbackup repository

1. Create repository directory *(change `/path/to/your/new/borgbackup/repository`)*:
   ```bash
   sudo mkdir /path/to/your/new/borgbackup/repository
   ```

2. Grant permissions:
   ```bash
   sudo chown remote-backup:remote-backup /path/to/your/new/borgbackup/repository
   ```

3. Switch to `remote-backup` user:
   ```bash
   su remote-backup
   ```

4. Initialize the repository *(change path)*:
   ```bash
   borg init --encryption=repokey-blake2 /path/to/your/new/borgbackup/repository
   ```

   You’ll be asked for a password — enter and confirm it.

5. *(Optional)* Test if the repository works:
   ```bash
   borg list /path/to/your/new/borgbackup/repository
   ```

---

### SECTION 5 — Create service and socket

1. Create service *(change `your_service_name`)*:
   ```bash
   sudo touch /etc/systemd/system/your_service_name@.service
   ```

2. Write configuration (see example → `server/host/etc/systemd/system/example@.service`)

3. Create socket *(change `your_name_for_socket`)*:
   ```bash
   sudo touch /etc/systemd/system/your_name_for_socket.socket
   ```

4. Write configuration (see example → `server/host/etc/systemd/system/example.socket`)

⚠️ The `remote-backup` user must have permissions to the socket directory:
```bash
sudo chown remote-backup:remote-backup /path/where/the/sock/will/be/
```

---

### SECTION 6 — Create backup configuration, backup script, and restore script

1. Switch to `remote-backup` user:
   ```bash
   su remote-backup
   ```

2. Create backup directory:
   ```bash
   mkdir ~/backup
   ```

3. Set permissions:
   ```bash
   chmod 700 ~/backup
   ```

4. Create backup config file (see example → `server/host/home/backup/backup.conf`):
   ```bash
   nano ~/backup/backup.conf
   ```

5. Create backup script (see example → `server/host/home/backup/run_backup.sh`):
   ```bash
   nano ~/backup/run_backup.sh
   ```

6. Create restore script (see example → `server/host/home/backup/run_restore.sh`):
   ```bash
   nano ~/backup/run_restore.sh
   ```

7. Set permissions:
   ```bash
   chmod 640 ~/backup/backup.conf
   chmod 755 ~/backup/run_backup.sh
   chmod 750 ~/backup/run_restore.sh
   ```

8. Set owners *(as root)*:
   ```bash
   sudo chown root:remote-backup /home/remote-backup/backup/backup.conf
   sudo chown root:root /home/remote-backup/backup/run_backup.sh
   sudo chown root:remote-backup /home/remote-backup/backup/run_restore.sh
   ```

⚠️ Some files will require root privileges for editing.

9. Add sudo permission for editing `backup.conf`:
   ```bash
   sudo nano /etc/sudoers
   ```
   *or*
   ```bash
   sudo visudo
   ```

10. Add line:
   ```bash
   remote-backup ALL=(ALL) /home/remote-backup/backup/change_backup_hour.sh, /usr/bin/nano backup.conf
   ```

---

### SECTION 7 — Install `crudini` and `curl` for ini parsing and Slack notifications

1. Update repositories:
   ```bash
   sudo apt update
   ```

2. Install tools:
   ```bash
   sudo apt install crudini curl
   ```

---

### SECTION 8 — Create backup service, timer, and script to change backup hours

1. Create backup service:
   ```bash
   sudo touch /etc/systemd/system/backup@.service
   ```

2. Paste config (See example → `backup@.service`):
   ```bash
   sudo nano /etc/systemd/system/backup@.service
   ```

3. Create timer and set time (see example → `backup@example.timer`):
   ```bash
   sudo nano /etc/systemd/system/backup@example.timer
   ```

⚠️ Match timer name to the client name from `backup.conf`, e.g.:
```text
backup@debian1.timer
```

4. Create `change_backup_hour.sh` script:
   ```bash
   sudo nano /home/remote-backup/backup/change_backup_hour.sh
   ```

5. Set permissions and owner:
   ```bash
   sudo chmod 755 /home/remote-backup/backup/change_backup_hour.sh
   sudo chown root:root /home/remote-backup/backup/change_backup_hour.sh
   ```

6. Allow execution via sudo:
   ```bash
   sudo nano /etc/sudoers
   ```
   *or*
   ```bash
   sudo visudo
   ```

7. Add line:
   ```bash
   remote-backup ALL=(ALL) /home/remote-backup/backup/change_backup_hour.sh
   ```

---

### SECTION 9 — Enable timers and sockets on startup

1. Enable timer *(change `your_timer_name`)*:
   ```bash
   sudo systemctl enable backup@your_timer_name.timer
   ```

2. Enable socket *(change `your_name_for_socket`)*:
   ```bash
   sudo systemctl enable your_name_for_socket.socket
   ```

3. Start socket:
   ```bash
   sudo systemctl start your_name_for_socket.socket
   ```

## 📁 synology_nas.md

### SECTION 1 — Enable necessary options

1. Enable SSH connection on port 22 on your NAS

2. Enable the option that adds home directories for users:  
   **Control Panel → Users and Groups → Advanced → Enable user home folder service**

---

### SECTION 2 — Install Docker

1. Go to `packages center` on your nas web ui

2. Search for `docker`

3. Click `install`

---

### (Optional) — Nano editor (You need to have Entware installed [unofficial])

1. Install nano:
   ```bash
   /opt/bin/opkg install nano
   ```
   If it fails:
   ```bash
   sudo /opt/bin/opkg install nano
   ```

---

### SECTION 3 — Create borg user and create a script

1. Add borg user:
   ```bash
   sudo synouser --add borg your_password "Borg Backup" 0 "" ""
   ```
   ⚠️ Change `your_password` with valid value

2. Change default shell after each reboot (use your text editor):
   ```bash
   sudo /opt/bin/nano /usr/local/etc/rc.d/set-borg-shell.sh
   ```

3. Paste:
   ```sh
   #!/bin/sh
   sed -i 's|^borg:.*:/sbin/nologin$|borg:x:1027:100:Borg Backup:/var/services/homes/borg:/bin/sh|' /etc/passwd
   ```

   ⚠️ Replace `1027` and `100` with correct values, you can use `id borg` command

4. Set permissions:
   ```bash
   sudo chmod +x /usr/local/etc/rc.d/set-borg-shell.sh
   ```

---

### SECTION 4 — Add server’s SSH key to NAS

1. On backup server (as `remote-backup`):
   ```bash
   cat /home/remote-backup/.ssh/your_public_ssh_key.pub
   ```

2. Copy output

3. On NAS (use your text editor) (as `borg`):
   ```bash
   mkdir -p /var/services/homes/borg/.ssh
   /opt/bin/nano /var/services/homes/borg/.ssh/authorized_keys
   ```

4. Paste key:
   ```
   ssh-ed25519 <YOUR_KEY> backup-pull-key
   ```

---

### SECTION 5 — Enable SSH access to `borg` user

1. Edit SSH config (use your text editor):
   ```bash
   sudo /opt/bin/nano /etc/ssh/sshd_config
   ```

2. Change or add:
   ```bash
   AllowTcpForwarding yes
   StreamLocalBindUnlink yes
   ```

3. Restart SSH:
   ```bash
   sudo synosystemctl restart sshd.service
   ```

---

### SECTION 6 - Give borg user permissions to run docker command 

1. Edit sudoers (use your text editor):
    ```bash
    sudo /opt/bin/nano /etc/sudoers.d/borg
    ```

2. Write configuration (only for a while to build image):
   ```bash
   borg ALL=(ALL) NOPASSWD:SETENV: /usr/local/bin/docker
   ```

---

### SECTION 7 - Set up Dockerfile, entrypoint and keygen.conf

1. Create backup catalogue (as `borg`):
    ```bash
    mkdir ~/backup
    ```
2. Create `Dockerfile`, `entrypoint.sh` and `keygen.conf` in backup catalogue (as `borg`):
    ```bash
    touch ~/backup/Dockerfile ~/backup/entrypoint.sh ~/backup/keygen.conf
    ```
3. Write Dockerfile configuration see:
   > [example](/clients/docker/Dockerfile)

   **⚠️ Replace `your_password_for_borg_repository` and `/path/to/your/pass/password/for/borgbackup/repo` with valid values.**

4. Write entrypoint.sh configuration see:
   > [example](/clients/docker/entrypoint.sh)

5. Write your keygen.conf configuration see:
   > [example](/clients/keygen.conf)

---

### SECTION 8 - Build your Docker Image

1. Make sure that you are in the catalogue where `Dockerfile` is stored (as `borg`):
    ```bash
    cd ~/backup
    ```

2. Build your image:
    ```bash
    sudo docker build -t nas .
    ```

### SECTION 9 - Change docker command execution permissions for borg user

1. Edit sudoers (use your text editor):
    ```bash
    sudo /opt/bin/nano /etc/sudoers.d/borg
    ```

2. Write configuration see:
   > [example](/clients/docker/nas-synology/borg)

---


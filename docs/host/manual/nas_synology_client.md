
## 📁 synology_nas.md

### SECTION 1 — Enable necessary options

1. Enable SSH connection on port 22 on your NAS

2. Enable the option that adds home directories for users:  
   **Control Panel → Users and Groups → Advanced → Enable user home folder service**

---

### SECTION 2 — Install Entware

1. Connect to your Synology NAS server:
   ```bash
   ssh root@nas_ip_address
   ```

2. Create directory for Entware:
   ```bash
   mkdir -p /volume1/@entware
   ```

3. Switch directory:
   ```bash
   cd /volume1/@entware
   ```

4. Check your processor architecture:
   ```bash
   uname -m
   ```

5. Go to: [entware](https://bin.entware.net/) and choose the correct path based on architecture (e.g. `https://bin.entware.net/x64-k3.2/installer/generic.sh`)

6. Download the correct `generic.sh`:
   ```bash
   wget http://bin.entware.net/YOUR_PROCESSOR_ARCHITECTURE/installer/generic.sh
   ```

7. Set permissions:
   ```bash
   chmod +x generic.sh
   ```

8. Run script:
   ```bash
   ./generic.sh
   ```

9. Test:
   ```bash
   sudo /opt/bin/opkg update
   ```

---

### *(Optional)* SECTION 2.1 — Nano editor

1. Install nano:
   ```bash
   /opt/bin/opkg install nano
   ```
   If it fails:
   ```bash
   sudo /opt/bin/opkg install nano
   ```

---

### *(Optional)* SECTION 2.2 — Entware access after reboot

1. Edit startup script:
   ```bash
   sudo /opt/bin/nano /usr/local/etc/rc.d/entware-start.sh
   ```

2. Paste:
   ```sh
   #!/bin/sh

   # Entware startup script
   OPT_DIR="/volume1/@entware/opt"

   mount -o bind ${OPT_DIR} /opt
   export PATH=/opt/bin:/opt/sbin:$PATH
   [ -x /opt/etc/init.d/rc.unslung ] && /opt/etc/init.d/rc.unslung start
   ```

3. Set permissions:
   ```bash
   sudo chmod +x /usr/local/etc/rc.d/entware-start.sh
   ```

---

### SECTION 3 — Install socat and borgbackup

1. Update Entware:
   ```bash
   sudo /opt/bin/opkg update
   ```

2. Install socat and borgbackup:
   ```bash
   sudo /opt/bin/opkg install borgbackup socat
   ```

---

### SECTION 4 — Add borg user

1. Add borg user (replace password):
   ```bash
   sudo synouser --add borg your_password "Borg Backup" 0 "" ""
   ```

2. Change default shell after each reboot:
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

### SECTION 5 — Sudoers access for borg user

1. Create directory and set permissions:
   ```bash
   mkdir -p /etc/sudoers.d
   sudo chmod 755 /etc/sudoers.d
   ```

2. Create borg sudoers file:
   ```bash
   sudo /opt/bin/nano /etc/sudoers.d/borg
   ```

3. Paste:
   ```bash
   borg ALL=(root:root) NOPASSWD:SETENV: /opt/bin/borg
   ```

4. Set permissions:
   ```bash
   sudo chmod 440 /etc/sudoers.d/borg
   sudo chown root:root /etc/sudoers.d/borg
   ```

5. Edit `/etc/sudoers`:
   Change:
   ```bash
   #includedir /etc/sudoers.d
   ```
   to:
   ```bash
   @includedir /etc/sudoers.d
   ```

---

### SECTION 6 — Add server’s SSH key to NAS

1. On NAS (as `borg`):
   ```bash
   mkdir -p /var/services/homes/borg/.ssh
   ```

2. Edit the `authorized_keys` file (use your text editor):
   ```bash
   /opt/bin/nano /var/services/homes/borg/.ssh/authorized_keys
   ```

3. Paste the SSH public key from the backup server (see: [How to copy 2.1](/docs/host/manual/debian_server.md)):
   ```
   ssh-ed25519 <YOUR_KEY> borg-backup
   ```

---

### SECTION 7 — Enable SSH access to `borg` user

1. Edit SSH config:
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

### *(Optional)* SECTION 8 — Install pass on NAS

1. Go to /opt:
   ```bash
   cd /opt
   ```

2. Download pass:
   ```bash
   sudo wget https://git.zx2c4.com/password-store/snapshot/password-store-master.tar.xz
   ```

3. Extract:
   ```bash
   sudo tar -xf password-store-master.tar.xz
   ```

4. Enter extracted dir:
   ```bash
   cd password-store-master
   ```

5. Install dependencies:
   ```bash
   sudo /opt/bin/opkg install make bash coreutils findutils grep sed pinentry
   ```

6. Build and install pass:
    sudo make install

7. Test:
   ```bash
   /opt/bin/pass --version
   ```

---

### SECTION 9 — Create GPG key and password repo (as `borg` user)

1. Create GPG directory:
   ```bash
   mkdir -p ~/.gnupg
   chmod 700 ~/.gnupg
   ```

2. Edit agent config:
   ```bash
   /opt/bin/nano ~/.gnupg/gpg-agent.conf
   ```

3. Paste:
   ```text
   pinentry-program /opt/bin/pinentry
   ```

4. Restart agent:
   ```bash
   gpgconf --kill gpg-agent
   gpgconf --launch gpg-agent
   ```

5. Create `keygen.conf` (see: [example](/clients/host/keygen.conf)):
   ```bash
   /opt/bin/nano ~/keygen.conf
   ```

6. Generate key:
   ```bash
   gpg --batch --generate-key ~/keygen.conf
   ```

7. List keys:
   ```bash
   gpg --list-keys
   ```

8. Copy key ID (example):
   ```
   E5435GDSGIOSDF90345DSGOJSGD34DGSF
   ```

9. Init pass repo:
   ```bash
   /opt/bin/pass init paste_your_copied_string
   ```

10. Insert password:
   ```bash
   /opt/bin/pass insert repositories/borg/nas1
   ```

11. Remove config:
   ```bash
   rm -f ~/keygen.conf
   ```

12. *(Optional)* Test:
   ```bash
   /opt/bin/pass show repositories/borg/nas1
   ```
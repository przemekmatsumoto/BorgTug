## 📁 debian_client.md

### SECTION 1 — Install dependencies

1. Install ssh, socat, borgbackup:
   ```bash
   sudo apt install ssh socat borgbackup -y
   ```

### SECTION 2 — Connect to the server

1. Connect to your Debian server:
   ```bash
   ssh your_user_with_root_privileges@debian_ip_address
   ```

### SECTION 3 — Add and configure the borg user

1. Add the borg user:
   ```bash
   sudo adduser borg
   ```
   Go through the setup, create a password (the rest is optional), and confirm by pressing T and Enter at the end.

2. Create the file `/etc/sudoers.d/borg`:
   ```bash
   sudo nano /etc/sudoers.d/borg
   ```

3. Paste the line:
   ```bash
   borg ALL=(root:root) NOPASSWD:SETENV: /usr/bin/docker
   ```

4. Set the correct permissions:
   ```bash
   sudo chmod 0440 /etc/sudoers.d/borg
   sudo chown root:root /etc/sudoers.d/borg
   ```

5. You can check if it works:
   ```bash
   sudo visudo -f /etc/sudoers.d/borg
   ```

---

### SECTION 4 — Add server’s SSH key to Debian client

1. On debian client (as `borg`):
   ```bash
   mkdir -p ~/.ssh
   nano /home/borg/.ssh/authorized_keys
   ```

2. Edit the `authorized_keys` file:
   ```bash
   nano ~/.ssh/authorized_keys
   ```

3. Paste the SSH public key from the backup server (see: [How to copy 2.1](/docs/host/manual/debian_server.md)):
   ```
   ssh-ed25519 <YOUR_KEY> borg-backup
   ```

---

### SECTION 5 — Change SSH config 

1. Edit the `/etc/ssh/sshd_config` file:
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```

2. Set:
   ```
   AllowTcpForwarding no
   StreamLocalBindUnlink no
   ```
   to:
   ```
   AllowTcpForwarding yes
   StreamLocalBindUnlink yes
   ```

3. Save and exit (`Ctrl+S` and `Ctrl+X`)

4. Restart SSH:
   ```bash
   sudo systemctl restart sshd.service
   ```

---

### SECTION 6 *(OPTIONAL)* — Install `pass` for password handling on the client

1. Install `pass`:
   ```bash
   sudo apt install pass
   ```

2. As the borg user, create a directory for the GnuPG key:
   ```bash
   su borg
   mkdir -p ~/.gnupg
   ```

3. Set permissions:
   ```bash
   chmod 700 ~/.gnupg
   ```

4. Create the `keygen.conf` file (see: [example](/clients/host/keygen.conf)):
   ```bash
   nano ~/keygen.conf
   ```

5. Generate the key:
   ```bash
   gpg --batch --generate-key keygen.conf
   ```

6. Check if the key appears:
   ```bash
   gpg --list-keys
   ```

7. Copy the long string (example):
   ```
   E5435GDSGIOSDF90345DSGOJSGD34DGSF
   ```

8. Initialize the pass repository:
   ```bash
   pass init paste_your_copied_string
   ```

9. Create a password for the borg repository:
    ```bash
    pass insert repositories/borg/debian1
    ```

10. Remove `keygen.conf`:
    ```bash
    rm -f ~/keygen.conf
    ```

11. *(Optional)* Check if it works:
    ```bash
    pass show repositories/borg/debian1
    ```
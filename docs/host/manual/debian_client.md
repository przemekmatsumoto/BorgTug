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

2. Edit the sudoers file:
   ```bash
   sudo visudo
   ```

   *(OPTIONAL)*

   2.1 Create the file `/etc/sudoers.d/borg`:
   ```bash
   sudo nano /etc/sudoers.d/borg
   ```

   2.2 Paste the line:
   ```bash
   borg ALL=(root:root) NOPASSWD:SETENV: /usr/bin/borg
   ```

   2.3 Set the correct permissions:
   ```bash
   sudo chmod 0440 /etc/sudoers.d/borg
   sudo chown root:root /etc/sudoers.d/borg
   ```

   2.4 You can check if it works:
   ```bash
   sudo visudo -f /etc/sudoers.d/borg
   ```

3. Add the following line in the edited file, then save and exit (`Ctrl+S` and `Ctrl+X`):
   ```bash
   borg ALL=(root:root) NOPASSWD:SETENV: /usr/bin/borg
   ```

### SECTION 4 — Add the server's public key to the `.ssh` directory on the client to enable passwordless backup

1. Switch to the borg user:
   ```bash
   su borg
   ```

2. Change to the borg user's home directory:
   ```bash
   cd ~
   ```

3. Create the `.ssh` directory:
   ```bash
   mkdir .ssh
   ```

4. Edit the `authorized_keys` file:
   ```bash
   nano .ssh/authorized_keys
   ```

5. Paste the SSH public key from the backup server (see: [debian_server SECTION 2 point 3.1](debian_server.md)):
   ```
   ssh-ed25519 YOUR_RANDOM_KEY_STRING name
   ```

### SECTION 5 — Enable SSH connection to the borg user

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

4. Create the `keygen.conf` file:
   ```bash
   nano ~/keygen.conf
   ```

5. Paste the following:
   ```
   Key-Type: RSA
   Key-Length: 4096
   Subkey-Type: RSA
   Subkey-Length: 4096
   Name-Real: Borg Backup
   Expire-Date: 0
   %no-protection
   %commit
   ```

6. Generate the key:
   ```bash
   gpg --batch --generate-key keygen.conf
   ```

7. Check if the key appears:
   ```bash
   gpg --list-keys
   ```

8. Copy the long string (example):
   ```
   E5435GDSGIOSDF90345DSGOJSGD34DGSF
   ```

9. Initialize the pass repository:
   ```bash
   pass init paste_your_copied_string
   ```

10. Create a password for the borg repository:
    ```bash
    pass insert repozytoria/borg/debian1
    ```

11. Remove `keygen.conf`:
    ```bash
    rm -f ~/keygen.conf
    ```

12. *(Optional)* Check if it works:
    ```bash
    pass show repozytoria/borg/debian1
    ```
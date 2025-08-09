
## 📁 debian.md

### SECTION 1 — Install Docker

1. Update repository:
    ```bash
    sudo apt update
    ```

2. Install docker dependiences:
    ```bash
    sudo apt install ca-certificates curl gnupg lsb-release
    ```

3. Add official Docker GPG key:
    ```bash
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    ```

4. Add Docker repository:
    ```bash
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```

5. Update packages list:
    ```bash
    sudo apt update
    ```

6. Install Docker:
    ```bash
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

---

### SECTION 2 — Add borg user and give him permissions for docker command

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

### SECTION 3 — Add server’s SSH key to Debian client

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

### SECTION 4 — Change SSH config

1. Edit SSH config:
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```

2. Change or add:
   ```bash
   AllowTcpForwarding yes
   StreamLocalBindUnlink yes
   ```

3. Restart SSH:
   ```bash
   sudo systemctl restart sshd.service
   ```

---

### SECTION 5 - Set up Dockerfile, entrypoint and keygen.conf

1. Create backup directory (as `borg`):
    ```bash
    mkdir ~/backup
    ```
2. Create `Dockerfile`, `entrypoint.sh` and `keygen.conf` in backup directory (as `borg`):
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

### SECTION 6 - Build your Docker Image

1. Make sure that you are in the directory where `Dockerfile` is stored (as `borg`):
    ```bash
    cd ~/backup
    ```

2. Build your image:
    ```bash
    sudo docker build -t debian .
    ```

### SECTION 7 - Change docker command execution permissions for borg user

1. Edit sudoers (use your text editor):
    ```bash
    sudo nano /etc/sudoers.d/borg
    ```

2. Write configuration see:
   > [example](/clients/docker/debian/borg)

---

### (Optional) - Test if your container works

1. Run your container:
    ```bash
    sudo docker run --rm -v /:/data:ro -v /tmp:/tmp -it debian /bin/bash
    ```


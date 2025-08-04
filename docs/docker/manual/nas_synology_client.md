
## 📁 synology_nas.md

### SECTION 1 — Enable necessary options

1. Enable SSH connection on port 22 on your NAS

2. Enable the option that adds home directories for users:  
   **Control Panel → Users and Groups → Advanced → Enable user home folder service**

---

### Optional — Nano editor

1. Install nano:
   ```bash
   /opt/bin/opkg install nano
   ```
   If it fails:
   ```bash
   sudo /opt/bin/opkg install nano
   ```

---

### SECTION 2 — 
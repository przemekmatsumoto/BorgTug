# 📦 Backup Management Guide

## 1️⃣ Run Backup Manually  
**Script:** `run_backup.sh`  

> ⚠️  **WARNING!**  
> If you want to change this file you have to be in `/home/remote-backup/backup` catalogue.

**Command structure:**
```bash
./path_to_script specific_client
```

**Example:**
```bash
./run_backup.sh client2
```

---

## 2️⃣ Check / Change Time for Daily Backups  
**Script:** `change_backup_hour.sh`  

**Check backups time command structure:**
```bash
sudo /path_to_script
```

**Change time command structure:**
```bash
sudo /path_to_script specific_client new_time
```

**Example:**
```bash
sudo /home/remote-backup/backup/change_backup_hour.sh client2 03:00:00
```

---

## 3️⃣ Change Paths to Backup  
**File:** `backup.conf`  

> ⚠️ **WARNING!**  
> If you want to change this file you have to be in `/home/remote-backup/backup` catalogue because changing that file is restricted.  
> To edit that file, you need to use:
```bash
sudo nano backup.conf
```

Locate the line starting with `dirs` and modify it.  
You can add more than 1 path by placing them after a space.

**Example:**
```ini
dirs=/home/catalogue1 /root /etc
```
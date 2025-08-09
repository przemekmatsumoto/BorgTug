# BorgTug – Documentation

Welcome to the documentation of **BorgTug** – a tool for automatically backing up clients (Debian based distros, NAS) to a remote server using [BorgBackup](https://www.borgbackup.org/) in pull mode. How is this different from a regular backup? The backup server initiates the connection and download of backup files from clients, so you can freely choose what to back up on the server.

The project supports installation both **on the host system** and in **Docker containers**.

---

## 🚀 Quick Start

1. Configure your server:
   - [server](/docs/host/manual/debian_server.md)

2. Follow the relevant installation guide for client:
   >On Docker installation:
   - [Debian](/docs/docker/manual/debian_client.md)
   - [Synology NAS](/docs/docker/manual/nas_synology_client.md)
   >On Host installation:
   - [Debian](/docs/host/manual/debian_client.md)
   - [Synology NAS](/docs/host/manual/nas_synology_client.md)

3. Test your backup manually:  
   - [Tools](/tools/)

4. Set the automatic backup:
   - [Scripts Uage](how_to_use_scripts_on_server.md)

<!-- ## 👥 Who is this documentation for?

- **System administrators** who want a reliable backup system
- **Docker users** who need containerized backups
- **NAS owners** (Synology, etc.) integrating with BorgBackup
- **Open-source contributors** wanting to extend BorgTug -->

---

## 🔧 What will you find in the documentation?

### 🔹 General Information
- [How BorgTug works](/README.md)
- [Common issues and troubleshooting (FAQ)](/docs/TROUBLESHOOTING.md)
- [Debugging guide](/docs/DEBUGGING.md)

---

### 🗄️ Server Configuration
- [Debian – host installation](/docs/host/manual/debian_server.md)

---

### 🖥️ Client Configuration
- [Debian based distros – host installation](/docs/host/manual/debian_client.md)
- [Debian based distros – Docker installation](/docs/docker/manual/debian_client.md)
- [Synology NAS – host installation](/docs/host/manual/nas_synology_client.md)
- [Synology NAS – Docker installation](/docs/docker/manual/nas_synology_client.md)

---

### 📂 Example configuration files
- [Debian client](/clients/host/)
- [NAS Synology client](/clients/docker/)

---

## 📚 Related Documents

- [Troubleshooting guide](/docs/TROUBLESHOOTING.md)
- [Debugging tips](/docs/DEBUGGING.md)
- [Project README](/README.md)
- [Contributing guide](/CONTRIBUTING.md)

---

<!-- ## 🏗 Architecture Overview

```
gif
``` -->
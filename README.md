# 🪝 BorgTug — Automated & Manual Backup with BorgBackup in pull mode

**BorgTug** is an open-source tool for creating backups using [BorgBackup](https://www.borgbackup.org/) in **manual** or **automatic** mode, both on physical hosts and in Docker containers. The project supports environments (Debian based distros, Synology NAS). The backup server initiates the connection and download of backup files from clients, so you can freely choose what to back up on the server. You can see flow [here]()

---

## ✨ Features

- 📦 **BorgBackup** support in manual and automatic modes
- 🐳 Support for **Docker** and **physical hosts**
- 🖥️ Example configurations for **Debian**, **Synology NAS**
- 🔐 Encryption and integration with **SSH** and **pass**
- ⚙️ Easy customization for your own needs
- 📄 Detailed step-by-step [documentation](/docs/)

---

## 📂 Project structure

```
BorgTug/
├── clients/              # Client configurations (Docker/Host, Debian, NAS)
├── server/               # Files and for the backup server
├── docs/                 # Detailed documentation (installation, configuration, scenarios, toubleshooting)
├── tools/                # Additional tools
├── LICENSE               # Project license (MIT)
├── CONTRIBUTING.md       # Project contributing
└── README.md             # This file
```

---

## 🚀 Installation

1. **Read `Quick Start` section in [index](/docs/index.md) file**

2. **Configure the Server**

   - [Debian server](/docs/host/manual/debian_server.md)

3. **Choose the installation depending on your preferences**

   - [Docker — Debian based Client](/docs/docker/manual/debian_client.md)
   - [Docker — Synology NAS Client](/docs/docker/manual/nas_synology_client.md)
   - [Host — Debian based Client](/docs/host/manual/debian_client.md)
   - [Host — Synology NAS Client](/docs/host/manual/nas_synology_client.md)

2. **Follow the instructions**  
   Each `.md` file in `docs/` contains complete installation, configuration, and testing steps.

---

## 🛠 Requirements

- **BorgBackup** version ```>= 1.2, < 2.0```
- **socat**      version ```>= 1.7, < 2.0```
- **pass**       version ```>= 1.7, < 2.0```
- **Docker** (optional, for container environments) ```version >= 28.3, < 29.0```
- Configured SSH access (see [documentation](/docs/index.md))

---

## 🐛 Debugging & Troubleshooting

- For debugging tips, logs analysis, and developer notes, see [DEBUGGING.md](/docs/DEBUGGING.md)  
- For common issues, errors, and their solutions, see [TROUBLESHOOTING.md](/docs/TROUBLESHOOTING.md)

---

## 🤝 Contributing

We welcome bug reports, feature suggestions, and pull requests!  
Before contributing, please read [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 🔒 Security

If you discover a security vulnerability, **report it publicly via Issues**.  

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---

## 👨‍💻 Authors

- **Przemek Matsumoto** – Author and maintainer of the project
- Contributors – see [list of contributors](https://github.com/przemekmatsumoto/BorgTug/graphs/contributors)


# BorgTug – Documentation

Welcome to the documentation of **BorgTug** – a tool for automatically backing up clients (Linux, NAS) to a remote server using [BorgBackup](https://www.borgbackup.org/) in pull mode.

The project supports installation both **on the host system** and in **Docker containers**.

## 🔧 What will you find in the documentation?

### 🔹 General Information
- [How BorgTug works](../README.md)
- [Common issues and troubleshooting (FAQ)](./troubleshooting.md)

### 🖥️ Client Configuration
- [Debian – system installation](./host/manual/debian_client.md)
- [Debian – Docker installation](./docker/manual/debian_client.md)
- [Synology NAS – system installation](./host/manual/nas_synology_client.md)
- [Synology NAS – Docker installation](./docker/manual/nas_synology_client.md)

### 🗄️ Server Configuration
- [Debian – system installation](./host/manual/debian_server.md)
- [Debian – Docker installation](./docker/manual/debian_server.md)

### Example configuration structures
- [Debian client – system setup](../clients/host/debian/)
- [Debian client – Docker setup](../clients/docker/debian/)
- [NAS Synology client – system setup](../clients/host/nas%20synology/)
- [NAS Synology client – Docker setup](../clients/docker/nas%20synology/)

# BorgTug – Dokumentacja

Witamy w dokumentacji projektu **BorgTug** – narzędzia do automatycznego tworzenia kopii zapasowych klientów (Linux, NAS) na zdalnym serwerze przy użyciu [BorgBackup](https://www.borgbackup.org/) w trybie pull.

Projekt wspiera instalację zarówno **na systemie** jak i w **kontenerach Docker**.

## 🔧 Co znajdziesz w dokumentacji?

### 🔹 Ogólne informacje
- [Jak działa BorgTug](../README.md)
- [Najczęstsze problemy i ich rozwiązania (FAQ)](./troubleshooting.md)

### 🖥️ Konfiguracja klientów
- [Debian – instalacja systemowa](./host/manual/debian_client.md)
- [Debian – instalacja w Dockerze](./docker/manual/debian_client.md)
- [Synology NAS – instalacja systemowa](./host/manual/nas_synology_client.md)
- [Synology NAS – instalacja w Dockerze](./docker/manual/nas_synology_client.md)

### 🗄️ Konfiguracja serwera
- [Debian – instalacja systemowa](./host/manual/debian_server.md)
- [Debian – instalacja w Dockerze](./docker/manual/debian_server.md)

### Struktury z przykładową konfiguracją
- [Klient debian - struktura systemowa](../clients/host/debian/)
- [Klient debian - struktura w Dockerze](../clients/docker/debian/)
- [Klient nas synology - struktura systemowa](../clients/host/nas%20synology/)
- [Klient nas synology - struktura w Dockerze](../clients/docker/nas%20synology/)
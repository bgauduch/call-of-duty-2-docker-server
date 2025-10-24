# Call of Duty 2 server meets docker

[![Lint](https://github.com/bgauduch/call-of-duty-2-docker-server/workflows/Lint/badge.svg)](https://github.com/bgauduch/call-of-duty-2-docker-server/actions?query=workflow%3ALint)
[![Build, Test & Push](https://github.com/bgauduch/call-of-duty-2-docker-server/workflows/Build%2C%20Test%20%26%20Push/badge.svg)](https://github.com/bgauduch/call-of-duty-2-docker-server/actions?query=workflow%3A%22Build%2C+Test+%26+Push%22)
[![Docker Pulls](https://img.shields.io/docker/pulls/bgauduch/cod2server.svg)](https://hub.docker.com/r/bgauduch/cod2server/)

Launch a minimal & lightweight containarized [Call of Duty 2](https://en.wikipedia.org/wiki/Call_of_Duty_2) multiplayer game server, including libcod.

## 📦 Docker Images

Images are available on [Docker Hub](https://hub.docker.com/r/bgauduch/cod2server/tags) for all [17 server variants](bin/readme.md) (COD2 versions 1.0/1.2/1.3 with voron/ibuddieat libcod libraries).

### Quick Start

```yaml
# Production - immutable tag (recommended)
image: bgauduch/cod2server:6.0.0-1_3_nodelay_va_loc-ibuddieat

# Development - latest default variant
image: bgauduch/cod2server:latest
```

### Available Tags

* **Immutable (recommended):** `6.0.0-1_3_nodelay_va_loc-ibuddieat` - Full version + variant + libcod
* **Version tags:** `latest`, `6`, `6.0`, `6.0.0` - Default variant only (`1_3_nodelay_va_loc-ibuddieat`)
* **Variant tags:** `1_3_nodelay_va_loc-ibuddieat`, `1_3_nodelay_va_loc-voron`, `1_2_c_nodelay-voron`, etc. - Latest build per variant

See [CONTRIBUTING.md](CONTRIBUTING.md#docker-image-tags) for complete tagging strategy and [bin/readme.md](bin/readme.md) for variant explanations.

## 🔧 What's Inside

* **Server binaries:** `cod2_lnxded` from [Killtube](https://killtube.org/showthread.php?1719-Latest-cod2-linux-binaries-(1-0-1-2-1-3)) by [Kung Foo Man](https://github.com/kungfooman) and [Mitch](https://github.com/M-itch)
* **LibCOD:** Custom [libcod](https://github.com/voron00/libcod) by [Voron00](https://github.com/voron00) or [zk_libcod](https://github.com/ibuddieat/zk_libcod) by [iBuddieAt](https://github.com/iBuddieAt) depending on selected image tag

Full credits to them for their awesome work!

## 📝 Requirements

* Original Call of Duty 2 game files (`.iwd` files from retail copy, Steam or [archive.org](https://archive.org/details/dev-cod2))
* x86_64 host machine
* [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)

## 🚀 Quick Start

1. **Clone repository:**

   ```bash
   git clone https://github.com/bgauduch/call-of-duty-2-docker-server.git
   cd call-of-duty-2-docker-server
   ```

2. **Add game files:**
   Copy `iw_XX.iwd` (00-15) and `localized_*_iwXX.iwd` from your game to `cod2server/main/`

3. **Configure server:**
   Edit `cod2server/main/server_mp.cfg`:
   * **⚠️ Change RCON password** (see [SECURITY.md](.github/SECURITY.md))
   * Update server name, admin, etc.

4. **Launch:**

   ```bash
   docker-compose up -d
   ```

### Server Management

```bash
docker-compose restart              # Restart server
docker-compose logs -f cod2_server  # View logs
docker-compose down                 # Stop server
```

For console commands and advanced usage, see [doc/readme.md](doc/readme.md).

## 📚 Documentation

* **[CONTRIBUTING.md](CONTRIBUTING.md)** - Development setup, testing, and contribution guidelines
* **[SECURITY.md](.github/SECURITY.md)** - Security best practices and vulnerability reporting
* **[doc/HISTORY.md](doc/HISTORY.md)** - Project history and community resources
* **[doc/readme.md](doc/readme.md)** - Server console commands

## 🤝 Contributing

Contributions are welcome! Please:

1. Check [existing issues](https://github.com/bgauduch/call-of-duty-2-docker-server/issues) or open a new one
2. Read [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines
3. Submit a [pull request](https://github.com/bgauduch/call-of-duty-2-docker-server/pulls)

## 📖 License

[MIT License](LICENSE) - See [releases](https://github.com/bgauduch/call-of-duty-2-docker-server/releases) for changelog.

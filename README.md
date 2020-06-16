[![image build](https://github.com/bgauduch/call-of-duty-2-docker-server/workflows/lint-build-push/badge.svg)](https://github.com/bgauduch/call-of-duty-2-docker-server/actions?query=workflow%3Alint-build-push)
[![Docker Pulls](https://img.shields.io/docker/pulls/bgauduch/cod2server.svg)](https://hub.docker.com/r/bgauduch/cod2server/)

# Call of Duty 2 server meets docker
Launch a minimal & lightweight containarized [Call of Duty 2](https://en.wikipedia.org/wiki/Call_of_Duty_2) multiplayer game server, including libcod.

## 📦 Supported tags and respective `Dockerfile` links
This repository use a multi-build setup to provide images for all server binaries located in the [`/bin` folder](https://github.com/bgauduch/call-of-duty-2-docker-server/tree/master/bin).
All image tags can be found on the [Docker Hub registry](https://hub.docker.com/r/bgauduch/cod2server/tags).

The following convention is applied:
* **`bgauduch/cod2server:latest`** - [Dockerfile](https://github.com/bgauduch/call-of-duty-2-docker-server/blob/master/Dockerfile)
  * uses latest available cracked server binary and libcod library, build from `master` branch.
* **`bgauduch/cod2server:3.0`** - [Dockerfile](https://github.com/bgauduch/call-of-duty-2-docker-server/blob/3.0/Dockerfile) - equivalent to `latest` on release tag.
* **`bgauduch/cod2server:X_Y_zzzzzz`**
  * **`X_Y`** is the server binary and libcod library version in [`1_0`, `1_2`, `1_3`];
  * **`zzzzzz`** is the server binary declination. Report to the [readme in the `/bin` folder](https://github.com/bgauduch/call-of-duty-2-docker-server/tree/master/bin) for explanations.

Please report to the [releases section](https://github.com/bgauduch/call-of-duty-2-docker-server/releases) for the changelogs. Any other image tag is not supported.

## 🔧 What's inside
* The `cod2_lnxded` server binary from [Killtube](https://killtube.org/showthread.php?1719-Latest-cod2-linux-binaries-(1-0-1-2-1-3)) by [Kung Foo Man](https://github.com/kungfooman), [Mitch](https://github.com/M-itch) and anyone that contributed;
* The [custom `libcod`](https://github.com/voron00/libcod) from [Voron00](https://github.com/voron00), follow the repository forks for a complete list of creators and contributors.

> Full credits goes to them for their awesome work !

## 📝 Requirements
* The orginal game, as it's content is used by the dedicated server;
* A host machine of your choice with x86_64 architecture;
* [Docker](https://docs.docker.com/install/linux/docker-ce/debian/) and [Docker Compose](https://docs.docker.com/compose/install/) installed and configured on your host machine.
Minimal knowledge in using both is recommended.

## 🚀 Usage

### Setup the server
1. Clone or download this repository on your host machine;
1. Copy required data from the `main` folder of your original game (install directory or retail DVD) to the server:
    1. Copy all the `iw_XX.iwd` from 00 to 15 to the `cod2server/main` folder;
    1. Copy all the localizations `localized_english_iwXX.iwd` to the `cod2server/main` (it might be another language).
1. Edit the config file located in `cod2server/main/server_mp.cfg` to suits your needs:
    1. **[MANDATORY] Set the RCON password to something strong and private!**
    1. Tweak the rest as you see fit, don't forget to updated the placeholders (server name, admin, etc).
1. *[Optional]* If you need Punkbuster:
  1. Activate it by changing `sv_punkbuster` from `0` to `1` in the command arguments of the `docker-compose.yaml`file;
  1. Edit the `cod2server/main/punkbuster.cfg` configuration to suits your needs.
1. *[Optional]* Edit the `bgauduch/cod2server` image tag in `docker-compose.yaml` to choose a different server version;
1. Depending on your setup, you might have some port-forwarding and firewalling to do in order to make your server publicly available (see required open ports in the `EXPOSE` section of the [Dockerfile](https://github.com/bgauduch/call-of-duty-2-docker-server/blob/master/Dockerfile)).

### Launch the server
From the project root:
``` bash
docker-compose up -d
```

### Server interactions
From the project root, you can:

* Restart the server (to pick up config change for instance):
  ```sh
  docker-compose restart
  ```
* Tail the server logs:
  ```sh
  # cod2_server refer to the name of the service in the compose file
  docker-compose logs -f cod2_server
  ```
* Attach a shell to the server to run commands, see available commands in [/doc/readme.md](https://github.com/bgauduch/call-of-duty-2-docker-server/blob/master/doc/readme.md):
  ```sh
  docker container attach call-of-duty-2-docker-server_cod2_server_1
  # exemple commands
  status
  map_rotate
  # Use the escape sequence to detach: `CTRL+P`, `CTRL+Q`
  ```
  >
* Completely stop the server:
  ```sh
  docker-compose down
  ```

## 💻 Development guidelines
If you wish to contribute to and improve this project, you can do so by cloning it and then follow theses guidelines :

### Start / restart the server locally
```sh
./scripts/dev-up.sh
```
> Note that you will need the game files in the main folder, as specified in the "Requirements" section.

### Show server logs
```sh
./scripts/dev-logs.sh
```

### Execute server commands
Attach a shell to the running server process to run a command, see available commands in [/doc/readme.md](https://github.com/bgauduch/call-of-duty-2-docker-server/blob/master/doc/readme.md):
```sh
./scripts/dev-attach.sh
# Exemple commands
status
map_rotate
# Use the escape sequence to detach: `CTRL+P`, `CTRL+Q`
```

### Run a shell in the server container
You can debug directly inside the server container (show file structure, tail logs, etc):
```sh
./scripts/dev-exec.sh
```

### Cleanup
Remove everything once your tests are over:
```sh
./scripts/dev-down.sh
```

## 🗂️ Notes & resources

* This setup was tested on an ubuntu server 18.04.3 LTS x86_64 and should work on any platform with the same architecture.
* Threads on setting up a cod2 server are availables on [Killtube](https://killtube.org/forum.php):
  * [on ubuntu 14.04](https://killtube.org/showthread.php?2454-Work-in-progress-Setup-CoD2-on-your-ubuntu-14-04-server) by IzNoGoD
  * [using Docker](https://killtube.org/showthread.php?3167-CoD2-Setup-CoD2-with-Docker) by Lonsofore
* There is a similar repository on github proposing a Call of Duty 2 server based on CentOS: [hberntsen/docker-cod2](https://github.com/hberntsen/docker-cod2)
* Original and cracked server binaries can be found in the [`bin`](https://github.com/bgauduch/call-of-duty-2-docker-server/tree/master/bin) folder, have a look at the `readme`
* If you need to use iptables in conjonction with Docker, please follow the [official documentation tips](https://docs.docker.com/network/iptables/)

## 🚧 Roadmap
Project roadmap & issues can be tracked on the [project page](https://github.com/bgauduch/call-of-duty-2-docker-server/projects/2).

## 🙏 Contribution
Any contribution to this project is welcome ! Feel free to [open an issue](https://github.com/bgauduch/call-of-duty-2-docker-server/issues/new) to ask for help or a new feature, and it will be discussed there.

If you wish to contribute to the code, start by reading the development guidelines and then feel free to [open a pull-request](https://github.com/bgauduch/call-of-duty-2-docker-server/pulls).

## 📖 License
This project is under the [MIT License](https://choosealicense.com/licenses/mit/).

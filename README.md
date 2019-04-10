# Call of Duty 2 server meet docker

Launch a minimal containarized [Call of Duty 2](https://en.wikipedia.org/wiki/Call_of_Duty_2) multiplayer game server.

Currently it use:
- The `cod2_lnxded_1_3_nodelay_va_loc` server binary from [Killtube](https://killtube.org/showthread.php?1719-Latest-cod2-linux-binaries-(1-0-1-2-1-3)) by **Kung Foo Man**, **Mitch** and anyone that contributed;
- The [custom `libcod`](https://github.com/voron00/libcod) from **Voron00**, follow the forks for the origin.

Full credits goes to them.

## Prerequisites
You will need the following things:
1. The linux dedicated server binary, which can be found in this repository in the `bin` folder;
1. The orginal game, as it's contents are used by the dedicated server;
1. A host machine of your choice with x86_64 architecture;
1. [Docker](https://docs.docker.com/install/linux/docker-ce/debian/) and [Docker Compose](https://docs.docker.com/compose/install/) installed and configured on your host machine, obviously.

## Usage
Clone or download the repository and follow theses steps to get the server up and running:
1. Copy the required data from the game to the server:
    1. Go in the `main` folder of your original game (install directory or retail DVD);
    1. Copy all the `iw_XX.iwd` from 00 to 15 to the `cod2server/main` folder;
    1. Copy all the localizations `localized_english_iwXX.iwd` to the `cod2server/main` (it might be another language).
1. Edit the config file located in `cod2server/main/config.cfg` to suits your needs:
   * **[MANDATORY] Set the RCON password to something strong and private!**
   * Tweak the rest as you see fit, don't forget to updated the placeholders (server name, admin, etc).
1. From the project root, Launch the server:
    ``` bash
    docker-compose up -d
    ```
1. Depending on your setup, you might have some port-forwarding and firewalling to do in order to make your server publicly available.
1. And "voila" ! Availables server commands are listed in [/doc/readme.md](doc/readme.md), see next chapter for server interactions.

## Server interaction
From the project root, you can:
* Restart the server (to pick up config change for instance):
  ```bash
  docker-compose restart
  ```
* Tail the server logs:
  ```bash
  # cod2_server refer to the name of the service in the compose file
  docker-compose logs -f cod2_server
  ```
* Completely stop the server:
  ```bash
  docker-compose down
  ```

## Troobleshooting
* For `docker-compose` to pick up potential changes in the Dockerfile, force the image build: 
  ``` bash
  docker-compose up --build
  ```
* To choose another server binary, symply edit this file in the Dockerfile:
  ```docker
  COPY bin/BINARY_OF_YOUR_CHOICE /bin/cod2_lnxded
  ```

## Notes
* There is a similar repository on github proposing a Call of Duty 2 server based on CentOS: [hberntsen/docker-cod2](https://github.com/hberntsen/docker-cod2)
* A thread on setting up a cod2 server on ubuntu 14.04 is available [on killtube](https://killtube.org/showthread.php?2454-Work-in-progress-Setup-CoD2-on-your-ubuntu-14-04-server)
* This setup was tested on an ubuntu server 18.04.3 LTS x86_64 architecture and should work on any platform with the same architecture.
* You might want to use a separated host user to launch your docker containers. In this case do not forget to add him to the docker group. On Ubuntu for instance:
  ```bash
  # add user to docker group
  sudo gpasswd -a USER_NAME docker
  # restart docker dameon
  sudo service docker restart
  ```
* Original and cracked server binaries can be found in the 'bin' folder, have a look at the [readme](/bin/readme.md)
* The gcc3 library can be found in the `lib` folder, have a look at the [readme](/lib/readme.md).
* If you need to use iptables in conjonction with Docker, please follow the [official documentation tips](https://docs.docker.com/network/iptables/)

## Docker
If you are not familiar with docker (docker engine, docker hub, dockerfiles, docker images and containers), I suggest you have a look at the [documentation](https://docs.docker.com/) (especially the [dockerfiles](https://docs.docker.com/reference/builder/) part).

I also strongly recommend reading the [best practices for writing dockerfiles](https://docs.docker.com/articles/dockerfile_best-practices/) for a better understanding and a cleaner writing of dockerfiles.

[Docker](https://www.docker.com/) is useful, give it a try ;-)

## Roadmap
- [x]  Try to minimize the docker image using Scratch or Alpine instead of full featured OSs images (this implies to manually import all libraries and more)
- [x] Handle server logs (in the container or on a volume) : keeping default output from container, log handling is deffered to the host system.
- [X] Implement libcod base library
    - code: https://github.com/voron00/libcod
    - script doc: https://m-itch.github.io/codscriptdoc/
    - global info: https://killtube.org/showthread.php?1869-Script-documentation
    - full install thread: https://killtube.org/showthread.php?2454-CoD2-Setup-CoD2-on-your-ubuntu-14-04-server
- [ ] Add all libcod libs
- [ ] Placeholder replacement on startup to use environnement variables for server configuration
- [ ] Add CI for automatic image build & tooling (hadolint, container structure test, etc)
- [ ] Use builded image in the compose file instead of building locally
- [ ] Use Github project to host the roadmap and keep track of changes
- [ ] Try to optimize the libstdc++ copy for runtime (if possible ? most certainly symlinks to deal with), check with wagoodman/dive

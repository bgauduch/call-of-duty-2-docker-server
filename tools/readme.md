# Tools for debug & dev

## Golang cat
Golang implementation like cat, usefull to cat a file in a shell-less environnement.

Usage :
- build the binary:
  ```bash
  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o cat
  ````
- Copy the binary in the Dockerfile:
  ```docker
  COPY tools/cat /cat
  ````
- Use the tools on the desired file÷
  ```bash
  # with docker directly
  docker container exec -it CONTAINER_ID /cat FILE_PATH
  # also possible with docker-compose
  docker-compose exec cod2_server /cat FILE_PATH
  ```

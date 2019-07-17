#!/usr/bin/env sh
set -euo pipefail

# build local image
docker image build -t bgauduch/cod2-server:dev .

# launch cod2 server using local Dockerfile (docker-compose.dev override)
docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml up -d
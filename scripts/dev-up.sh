#!/usr/bin/env bash
set -euo pipefail

# build local image
docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml build

# launch cod2 server using local image (docker-compose.dev override)
docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml up -d

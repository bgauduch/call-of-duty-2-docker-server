#!/usr/bin/env bash
set -euo pipefail

# Build local image
docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml build

#!/usr/bin/env bash
set -euo pipefail

# Run a shell in the server container
docker-compose exec cod2_server sh

#!/usr/bin/env bash
set -euo pipefail

# Run a shell in the server containber
docker-compose exec -it cod2_server sh

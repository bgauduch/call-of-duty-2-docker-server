#!/usr/bin/env sh
set -euo pipefail

# execute a shell in the server service
docker-compose exec cod2_server sh

#!/usr/bin/env sh
set -euo pipefail

# tail stack logs
docker-compose logs -f cod2_server

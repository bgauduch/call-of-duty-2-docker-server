#!/usr/bin/env bash
set -euo pipefail

# tail stack logs
docker-compose logs -f cod2_server

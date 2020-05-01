#!/usr/bin/env bash
set -euo pipefail

# destroy cod2 server
docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml down --timeout 1

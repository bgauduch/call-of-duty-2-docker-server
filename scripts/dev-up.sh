#!/usr/bin/env bash
set -euo pipefail

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Build local image
"${SCRIPT_DIR}/dev-build.sh"

# Launch cod2 server using local image (docker-compose.dev override)
docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml up -d

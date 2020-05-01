#!/usr/bin/env bash
set -euo pipefail

# Run a shell in the server containber
docker container exec -it call-of-duty-2-docker-server_cod2_server_1 sh

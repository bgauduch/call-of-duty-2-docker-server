#!/usr/bin/env bash
#
# Container health check test script
# Tests that the COD2 server container starts and passes health checks
#
# Usage: ./test-container-health.sh IMAGE_NAME:TAG [GAME_FILES_PATH]
#
# Arguments:
#   IMAGE_NAME:TAG    - Docker image to test
#   GAME_FILES_PATH   - Optional path to game files directory (default: ./cod2server/main)
#

set -euo pipefail

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "Usage: $0 IMAGE_NAME:TAG [GAME_FILES_PATH]"
    echo ""
    echo "Examples:"
    echo "  $0 bgauduch/cod2server:latest"
    echo "  $0 bgauduch/cod2server:latest ./cod2server/main"
    exit 1
fi

IMAGE="$1"
GAME_FILES_PATH="${2:-./cod2server/main}"
CONTAINER_NAME="cod2-test-$$"

cleanup() {
    echo ""
    echo "Cleaning up..."
    docker stop "$CONTAINER_NAME" >/dev/null 2>&1 || true
    docker rm "$CONTAINER_NAME" >/dev/null 2>&1 || true
}

trap cleanup EXIT INT TERM

echo "=== COD2 Container Health Check Test ==="
echo "Image: $IMAGE"
echo ""

# Check if game files directory exists
if [ -d "$GAME_FILES_PATH" ]; then
    echo "Game files: $GAME_FILES_PATH (mounted)"
    VOLUME_MOUNT="-v $(cd "$GAME_FILES_PATH" && pwd):/home/cod2/main"
else
    echo "Game files: Not provided (testing without game files)"
    echo "Note: Container will fail initialization but process check will work"
    echo "      Provide game files path as second argument for full test"
    VOLUME_MOUNT=""
fi
echo ""

echo "Starting container..."
CONTAINER_ID=$(docker run -d \
    --name "$CONTAINER_NAME" \
    -p 28960:28960/udp \
    -p 28960:28960/tcp \
    $VOLUME_MOUNT \
    "$IMAGE" \
    +set dedicated 2 \
    +set sv_maxclients 32 \
    +set net_port 28960 \
    +map_rotate)

echo "Container ID: $CONTAINER_ID"
echo ""

# Wait for container to be running
echo "Waiting for container to start..."
for i in {1..30}; do
    if docker ps --filter "id=$CONTAINER_ID" --format "{{.Status}}" | grep -q "Up"; then
        echo "✓ Container is running (attempt $i/30)"
        break
    fi
    if [ "$i" -eq 30 ]; then
        echo "✗ Container failed to start within 30 seconds"
        echo ""
        echo "=== Container Logs ==="
        docker logs "$CONTAINER_NAME"
        exit 1
    fi
    sleep 1
done

echo ""

# Wait for health check to pass
echo "Waiting for health check to pass (max 60 seconds)..."
for i in {1..60}; do
    HEALTH=$(docker inspect --format='{{.State.Health.Status}}' "$CONTAINER_NAME" 2>/dev/null || echo "none")

    if [ "$HEALTH" = "healthy" ]; then
        echo "✓ Container is healthy! (attempt $i/60)"
        echo ""
        echo "=== Container Logs (first 30 lines) ==="
        docker logs "$CONTAINER_NAME" 2>&1 | head -n 30
        exit 0
    elif [ "$HEALTH" = "unhealthy" ]; then
        echo "✗ Container health check failed"
        echo ""
        echo "=== Container Logs ==="
        docker logs "$CONTAINER_NAME"
        exit 1
    fi

    # Show progress every 10 seconds
    if [ $((i % 10)) -eq 0 ]; then
        echo "  Status: $HEALTH (attempt $i/60)"
    fi

    sleep 1
done

# Timeout reached
echo "✗ Health check did not complete within 60 seconds"
echo "  Final status: $(docker inspect --format='{{.State.Health.Status}}' "$CONTAINER_NAME" 2>/dev/null || echo 'unknown')"
echo ""
echo "=== Container Logs ==="
docker logs "$CONTAINER_NAME"
exit 1

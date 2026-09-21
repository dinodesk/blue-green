#!/usr/bin/env bash
set -euo pipefail

docker compose stop api
echo "Docker service 'api' stopped."

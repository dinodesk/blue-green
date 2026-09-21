#!/usr/bin/env bash
set -euo pipefail

docker compose up -d api
docker compose ps api

echo "Docker service 'api' is running on http://127.0.0.1:8000"

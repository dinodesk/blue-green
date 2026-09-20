#!/usr/bin/env bash
set -euo pipefail
docker rm -f blue-green-dev >/dev/null 2>&1 || true
docker run --rm --name blue-green-dev -p 8000:8000 blue-green:dev

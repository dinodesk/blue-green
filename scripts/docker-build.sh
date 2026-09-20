#!/usr/bin/env bash
set -euo pipefail
docker build -t blue-green:dev .
echo "Built blue-green:dev"

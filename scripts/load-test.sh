#!/usr/bin/env bash
set -euo pipefail

URL="${1:-http://127.0.0.1:8000/health}"
REQUESTS="${REQUESTS:-50}"

if ! docker compose ps --status running --services | grep -qx "api"; then
    echo "Docker service 'api' is not running."
    echo "Start it first with: docker compose up -d"
    exit 1
fi

python - "$URL" "$REQUESTS" <<'PY'
import statistics
import sys
import time
import urllib.request

url, count = sys.argv[1], int(sys.argv[2])

if count <= 0:
    raise SystemExit("REQUESTS must be greater than zero")

latencies = []
failures = 0

for _ in range(count):
    started = time.perf_counter()
    try:
        with urllib.request.urlopen(url, timeout=5) as response:
            if response.status != 200:
                failures += 1
    except Exception:
        failures += 1
    latencies.append((time.perf_counter() - started) * 1000)

p95 = sorted(latencies)[max(0, int(count * 0.95) - 1)]
print(
    f"requests={count} failures={failures} "
    f"avg_ms={statistics.mean(latencies):.2f} p95_ms={p95:.2f}"
)

raise SystemExit(1 if failures else 0)
PY

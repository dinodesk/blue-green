#!/usr/bin/env bash
set -euo pipefail
URL="${1:-http://127.0.0.1:8000/health}"
REQUESTS="${REQUESTS:-50}"
python - "$URL" "$REQUESTS" <<'PY'
import statistics, sys, time, urllib.request
url, count = sys.argv[1], int(sys.argv[2])
latencies, failures = [], 0
for _ in range(count):
    started = time.perf_counter()
    try:
        with urllib.request.urlopen(url, timeout=5) as response:
            if response.status != 200:
                failures += 1
    except Exception:
        failures += 1
    latencies.append((time.perf_counter() - started) * 1000)
p95 = sorted(latencies)[max(0, int(count * .95) - 1)]
print(f"requests={count} failures={failures} avg_ms={statistics.mean(latencies):.2f} p95_ms={p95:.2f}")
raise SystemExit(1 if failures else 0)
PY

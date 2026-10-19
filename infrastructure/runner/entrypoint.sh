#!/usr/bin/env bash
set -euo pipefail
: "${GITHUB_REPOSITORY_URL:?Set GITHUB_REPOSITORY_URL}"
: "${RUNNER_TOKEN:?Set a short-lived runner registration token}"
cd /opt/actions-runner
cleanup() {
  ./config.sh remove --unattended --token "${RUNNER_TOKEN}" || true
}
trap cleanup EXIT INT TERM
./config.sh --unattended --url "${GITHUB_REPOSITORY_URL}" --token "${RUNNER_TOKEN}" --name "${RUNNER_NAME:-blue-green-windows-docker}" --labels "blue-green-local" --ephemeral --disableupdate
./run.sh

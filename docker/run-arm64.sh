#!/usr/bin/env bash
# Run gtsam-node from the project directory so test/resources/simulator.json resolves.
# Usage: docker run ... gtsam-playground:arm64 run [config_path] [extra args]
set -e
cd /workspace/gtsam-playground
exec ./export/bin/gtsam-node "$@"

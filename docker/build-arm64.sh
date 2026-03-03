#!/usr/bin/env bash
# Build script for arm64 container (native build)
# Expects /workspace/gtsam-playground to be mounted
# Usage: build (default) | run [config_path] [extra args]

set -e
if [[ "${1:-build}" == "run" ]]; then
  exec /usr/local/bin/run-gtsam.sh "${@:2}"
fi
PROJECT=/workspace/gtsam-playground
INSTALL_PREFIX="${PROJECT}/export"

cd "${PROJECT}"
mkdir -p build && cd build

cmake .. \
    -GNinja \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_EXE_LINKER_FLAGS="-fuse-ld=mold" \
    -DCMAKE_SHARED_LINKER_FLAGS="-fuse-ld=mold" \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
    -DCMAKE_PREFIX_PATH=/workspace/prefix

ninja -j$(nproc)
ninja install

# Compress gtsam-node executable
if [[ -f "${INSTALL_PREFIX}/bin/gtsam-node" ]]; then
    gzip -9 -k -f "${INSTALL_PREFIX}/bin/gtsam-node"
fi

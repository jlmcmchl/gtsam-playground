#!/usr/bin/env bash
# Build script for x86_64 container (cross-compilation to arm64)
# Expects /workspace/gtsam-playground to be mounted

set -e
WORK=/workspace
PROJECT=/workspace/gtsam-playground
INSTALL_PREFIX="${PROJECT}/export"

cd "${PROJECT}"
mkdir -p build && cd build

cmake .. \
    -GNinja \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_TOOLCHAIN_FILE=${WORK}/bookworm/toolchain-config.cmake \
    -DCMAKE_FIND_ROOT_PATH=${WORK}/prefix \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}"

ninja -j$(nproc)
ninja install

# Compress gtsam-node executable
if [[ -f "${INSTALL_PREFIX}/bin/gtsam-node" ]]; then
    gzip -9 -k -f "${INSTALL_PREFIX}/bin/gtsam-node"
fi

# Docker Build Environments

These Dockerfiles create reproducible build environments for gtsam-playground.

## x86_64 (Cross-compilation)

Builds an x86_64 container that cross-compiles to arm64, following the README cross-compilation instructions exactly. Includes the WPILib arm64 toolchain and a pre-built OpenCV prefix.

```bash
# Build the image
docker build -f docker/Dockerfile.x86_64 -t gtsam-playground:x86_64 .

# Run build (mount current dir to /workspace/gtsam-playground)
docker run --rm -v "$(pwd):/workspace/gtsam-playground" gtsam-playground:x86_64
```

Output: `export/` with `gtsam-node` (arm64) and `gtsam-node.gz`.

## arm64 (Native)

Builds an arm64 container for native builds. Builds OpenCV from source per README.

```bash
# Build the image (on arm64 host, or with buildx for emulation)
docker build -f docker/Dockerfile.arm64 -t gtsam-playground:arm64 .

# Build gtsam-playground
docker run --rm -v "$(pwd):/workspace/gtsam-playground" gtsam-playground:arm64

# Run gtsam-node (uses project CWD so test/resources/simulator.json resolves)
docker run --rm -v "$(pwd):/workspace/gtsam-playground" gtsam-playground:arm64 run
# Or with custom config: ... gtsam-playground:arm64 run /path/to/config.json
```

Output: `export/` with `gtsam-node` (arm64) and `gtsam-node.gz`.

## Common

Both images include: `build-essential`, `cmake`, `ninja-build`, `mold`, `git`, `jq`, `file`, `wget`, `curl`, `ca-certificates`, `unzip`, `zip`, `xz-utils`, `gzip`, `tar`, `pkg-config`.

The install target is `/workspace/gtsam-playground/export`. The `gtsam-node` executable is compressed with `gzip -9`.

#!/bin/bash
set -euxo pipefail

if [[ "$(uname)" == Darwin ]]; then
	export CFLAGS="${CFLAGS} -O3 -Wno-int-conversion -Wno-implicit-function-declaration"
fi

# cbindgen (needed to generate the Rust API header) is not packaged on conda-forge
CARGO_INSTALL_ROOT="${BUILD_PREFIX}" cargo install --locked cbindgen

# cmake's "find GSL" macro can pick up the wrong GSL in conda envs
GSL_ROOT_DIR="${PREFIX}" ${PYTHON} -m pip install . --no-deps --no-build-isolation --no-cache-dir -vvv

# libfwdpy11core is installed into site-packages, but the extension modules
# look for it in $PREFIX/lib (the rpath)
core=$(find "${SP_DIR}/fwdpy11" -name 'libfwdpy11core.*' -print -quit)
if [[ -n "${core}" ]]; then
	cp "${core}" "${PREFIX}/lib/"
fi

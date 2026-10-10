#!/bin/bash
set -exo pipefail

mkdir -p $PREFIX/bin

if [[ "$(uname -m)" == "x86_64" ]]; then
    # repackaged upstream binary
    cp gcta-1.94.1 $PREFIX/bin/gcta-1.94.1
else
    export EIGEN3_INCLUDE_DIR="${SRC_DIR}/eigen"
    export SPECTRA_LIB="${PREFIX}/include"
    export BOOST_LIB="${PREFIX}/include"
    export OPENBLAS="${PREFIX}"
    cmake -S . -B build ${CMAKE_ARGS} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    cmake --build build -j "${CPU_COUNT}"
    install -m 755 build/gcta64 $PREFIX/bin/gcta-1.94.1
fi

ln -s $PREFIX/bin/gcta-1.94.1 $PREFIX/bin/gcta
ln -s $PREFIX/bin/gcta-1.94.1 $PREFIX/bin/gcta64

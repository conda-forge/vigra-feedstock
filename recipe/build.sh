#!/bin/bash
set -ex
if [[ `uname` == 'Darwin' ]]; then
    EXTRA_CMAKE_ARGS="-DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET}"
    export LDFLAGS="-undefined dynamic_lookup ${LDFLAGS}"
else
    EXTRA_CMAKE_ARGS=""
    export CXXFLAGS="-pthread ${CXXFLAGS}"
fi

# In release mode, we use -O2 because gcc is known to miscompile certain vigra functionality at the O3 level.
# (This is probably due to inappropriate use of undefined behavior in vigra itself.)
export CXXFLAGS="-O2 ${CXXFLAGS}"
WITH_VIGRANUMPY=${WITH_VIGRANUMPY:-FALSE}

# Uncomment to debug finding python....
# CMAKE_FIND_DEBUG_MODE=1

# Configure
mkdir -p build
cd build
cmake ${CMAKE_ARGS} ..\
        -DWITH_BOOST_THREAD=1 \
        -DWITH_OPENEXR=1 \
        -DWITH_LEMON=1 \
        -DDEPENDENCY_SEARCH_PREFIX=${PREFIX} \
        -DCMAKE_FIND_DEBUG_MODE=${CMAKE_FIND_DEBUG_MODE} \
\
        -DPython_ROOT_DIR=${PREFIX} \
        -DPython_EXECUTABLE=${PYTHON} \
        -DPython_FIND_VIRTUALENV=ONLY \
        -DWITH_VIGRANUMPY=${WITH_VIGRANUMPY} \
        -DBoost_PYTHON_LIBRARY=${PREFIX}/lib/libboost_python${CONDA_PY}${SHLIB_EXT} \
\
        -DFFTW3F_INCLUDE_DIR=${PREFIX}/include \
        -DFFTW3F_LIBRARY=${PREFIX}/lib/libfftw3f${SHLIB_EXT} \
        -DFFTW3_INCLUDE_DIR=${PREFIX}/include \
        -DFFTW3_LIBRARY=${PREFIX}/lib/libfftw3${SHLIB_EXT} \
\
        -DHDF5_CORE_LIBRARY=${PREFIX}/lib/libhdf5${SHLIB_EXT} \
        -DHDF5_HL_LIBRARY=${PREFIX}/lib/libhdf5_hl${SHLIB_EXT} \
        -DHDF5_INCLUDE_DIR=${PREFIX}/include \
\
        -DBoost_INCLUDE_DIR=${PREFIX}/include \
        -DBoost_LIBRARY_DIRS=${PREFIX}/lib \
\
        -DZLIB_INCLUDE_DIR=${PREFIX}/include \
        -DZLIB_LIBRARY=${PREFIX}/lib/libz${SHLIB_EXT} \
\
        -DPNG_LIBRARY=${PREFIX}/lib/libpng${SHLIB_EXT} \
        -DPNG_PNG_INCLUDE_DIR=${PREFIX}/include \
\
        -DTIFF_LIBRARY=${PREFIX}/lib/libtiff${SHLIB_EXT} \
        -DTIFF_INCLUDE_DIR=${PREFIX}/include \
\
        -DJPEG_INCLUDE_DIR=${PREFIX}/include \
        -DJPEG_LIBRARY=${PREFIX}/lib/libjpeg${SHLIB_EXT} \
        ${EXTRA_CMAKE_ARGS}

make -j${CPU_COUNT} V=1 VERBOSE=1
# Can't run tests due to a bug in the clang compiler provided with XCode.
# For more details see here ( https://llvm.org/bugs/show_bug.cgi?id=21083 ).
# Also, these tests are very intensive, which makes them challenging to run in CI.
#eval ${LIBRARY_SEARCH_VAR}=$PREFIX/lib make check

make install

# if python has been built (i.e. vigra package, not libvigra)
if [[ "$PKG_NAME" == "vigra" ]]; then
    # if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
    # Probably too slow to run these tests on emulation...
    if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
        if [[ "${python_impl}" != "pypy" ]]; then
            make check_python
        fi
    fi
fi

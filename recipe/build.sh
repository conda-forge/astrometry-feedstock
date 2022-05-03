#!/bin/bash

# Remove ncurses tic.h that conficts with astrometry tic.h
rm -f $CONDA_PREFIX/include/tic.h
rm -f $PREFIX/include/tic.h

# Fix of Illegal Instructions
export ARCH_FLAGS=""
if [[ "$target_platform" == linux* ]]; then
    export CFLAGS="-march=x86-64 -mtune=generic -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -isystem $PREFIX/include -fdebug-prefix-map=$SRC_DIR=/usr/local/src/conda/astrometry-0.79 -fdebug-prefix-map=$PREFIX=/usr/local/src/conda-prefix"
    export DEBUG_CFLAGS="-march=x86-64 -mtune=generic -ftree-vectorize -fPIC -fstack-protector-all -fno-plt -Og -g -Wall -Wextra -fvar-tracking-assignments -ffunction-sections -pipe -isystem $PREFIX/include -fdebug-prefix-map=$SRC_DIR=/usr/local/src/conda/astrometry-0.79 -fdebug-prefix-map=$PREFIX=/usr/local/src/conda-prefix"
fi


# System packages config
export CFITS_INC="-I$PREFIX/include"
export CFITS_LIB="-L$PREFIX/lib -lcfitsio -lm"
export NETPBM_INC="-I$PREFIX/include -I$PREFIX/include/netpbm"
export NETPBM_LIB="-L$PREFIX/lib -lnetpbm"
export CAIRO_INC="-I$PREFIX/include -I$PREFIX/include/cairo"
export CAIRO_LIB="-L$PREFIX/lib -lcairo"
export PNG_INC="-I$PREFIX/include"
export PNG_LIB="-L$PREFIX/lib -lpng16"
export JPEG_INC="-I$PREFIX/include"
export JPEG_LIB="-L$PREFIX/lib -ljpeg"
export ZLIB_INC="-I$PREFIX/include"
export ZLIB_LIB="-L$PREFIX/lib -lz"
export SYSTEM_GSL=yes
export GSL_INC="-I$PREFIX/include"
export GSL_LIB="-L$PREFIX/lib -lgsl"
export WCSLIB_INC="-I$PREFIX/include -I$PREFIX/include/wcslib"
export WCSLIB_LIB="-L$PREFIX/lib -lwcs"

PY_VER ?= $(shell $(PYTHON) -c "from sys import version_info as v; print('python%i.%i' % (v.major,v.minor))")
export PY_BASE_INSTALL_DIR ?= $(INSTALL_DIR)/lib/$(PY_VER)/astrometry

# Making process
make -j${CPU_COUNT}
make extra
make py
make install INSTALL_DIR="$PREFIX"

# Move the default configuration file to avoid user config overwritten
mkdir -p "$PREFIX/share/astrometry"
mv "$PREFIX/etc/astrometry.cfg" "$PREFIX/share/astrometry/astrometry.cfg"

# Remove useless example files
rm -Rf "$PREFIX/examples"

# Remove useless doc folder
rm -Rf "$PREFIX/doc"


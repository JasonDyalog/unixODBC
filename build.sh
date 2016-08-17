#!/bin/bash

set -e


PLATFORM=`uname -s|tr '[A-Z]' '[a-z]'`
CPU=`uname -m|tr '[A-Z]' '[a-z]'`

if [ "$BUILD_WIDTH" ]; then
    BITS=$BUILD_WIDTH
elif [ "armv6l" = "${CPU}" ]; then
    ## Raspberry Pi
    BITS="32"
elif [ "darwin" = "${PLATFORM}" ]; then
    ## OS X
    BITS="64"
else
    ## Everything else
    BITS="64 32"
fi

echo "*****************************************************"
echo "**     Building for ${PLATFORM}-${CPU} (${BITS}bit)    **"
echo "*****************************************************"

if [ "darwin" = "${PLATFORM}" ]; then
    export SED=`which gsed`
    make -f Makefile.osx
else
    make -f Makefile.svn
fi

for WIDTH in ${BITS}; do
    PREFIX=${PWD}/distribution/${PLATFORM}-${CPU}-${WIDTH}
    mkdir -p ${PREFIX}


    if [ "32" = "${WIDTH}" ]; then
        echo "defaults for ${WIDTH}"
#         export CFLAGS="-m$BITS"
#         export CPPFLAGS="-m$BITS"
#         export CXXFLAGS="-m$BITS"
    elif [ "64" = "${WIDTH}" ]; then
        echo "defaults for ${WIDTH}"
    else
        echo "Unknown Width (${WIDTH})"
        exit 1
    fi

    ./configure --prefix=${PREFIX}
    make
    make install
    make clean
done




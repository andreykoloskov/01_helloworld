#!/bin/bash

echo "CREATE linux directory"

rm -rf build_linux
rm -rf src/gen
mkdir build_linux
cd build_linux

export TRAVIS_BUILD_NUMBER=1
export INTERNAL_BUILD_VARIABLE=1

cmake3 -D CMAKE_C_FLAGS=-m64 \
       	-DBOOST_ROOT=/mnt/hgfs/Documents/post_msu_prac/boost_1_73_0_linux \
	    -DBOOST_INCLUDEDIR=/mnt/hgfs/Documents/post_msu_prac/boost_1_73_0_linux/boost \
	    -DBOOST_LIBRARYDIR=/mnt/hgfs/Documents/post_msu_prac/boost_1_73_0_linux/stage/lib \
       ../

cmake3 --build . --config Release -- -j12
cmake3 --build . --config Debug -- -j12

cmake3 -E env CTEST_OUTPUT_ON_FAILURE=1
ctest . -C Release
ctest . -C Debug

cpack -C Release

cd ../

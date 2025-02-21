#!/usr/bin/env bash

rm -fr build
mkdir build
pushd build
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local ..
make 
make install
popd
#!/bin/bash

sudo apt install libglu1-mesa-dev -y
sudo apt install meson ninja-build
if [ ! -d "glu-9.0.3" ]; then
    if [ ! -f "glu-9.0.3.tar.gz" ]; then
        wget https://archive.mesa3d.org/glu/glu-9.0.3.tar.xz
    fi
    tar -xf glu-9.0.3.tar.xz
    rm glu-9.0.3.tar.xz
fi
cd glu-9.0.3
meson setup build
cd build
meson compile
sudo meson install
cd ../..

#!/bin/sh -l

export PATH=/gcc-arm-none-eabi-9-2019-q4-major/bin:$PATH
# Download OpenGD77 sources
cd ~ && git clone https://github.com/cifred98/OpenGD77

# Build and run binary downloader
cd ~/OpenGD77/tools/codec_dat_files_creator && \
    sed -i 's/\/\/#define USE_LIBCURL/#define USE_LIBCURL/' codec_dat_files_creator.c && \
    gcc -Wall -O2 -s `pkg-config libcurl --cflags` -o codec_dat_files_creator \
    codec_dat_files_creator.c -lcurl && \
    ./codec_dat_files_creator && cp codec_bin_section_*.bin ../../firmware/linkerdata

# Build firmware
cd ~/OpenGD77 && git checkout $1 && \
    cd firmware && mkdir build && cd build && make -j9 -f ../Makefile RADIO=$2

mv ~/OpenGD77/firmware/build/bin/*.sgl /github/workspace

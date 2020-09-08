#!/bin/sh -l

# Download OpenGD77 sources
git clone https://github.com/cifred98/OpenGD77

# Build and run binary downloader
cd /OpenGD77/tools/codec_dat_files_creator && \
    sed -i 's/\/\/#define USE_LIBCURL/#define USE_LIBCURL/' codec_dat_files_creator.c && \
    gcc -Wall -O2 -s `pkg-config libcurl --cflags` -o codec_dat_files_creator \
    codec_dat_files_creator.c -lcurl && \
    ./codec_dat_files_creator && cp codec_bin_section_*.bin ../../firmware/linkerdata

# Build firmware
cd /OpenGD77 && git checkout $1 && \
    cd firmware && mkdir build && cd build && make -j9 -f ../Makefile

mv /OpenGD77/firmware/build/bin/OpenGD77.sgl /github/home

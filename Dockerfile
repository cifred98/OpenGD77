#
# OpenGD77 Continuous Integration Docker Image
#
FROM debian:latest
MAINTAINER "Niccolò Izzo IU2KIN <n@izzo.sh>"

# Install dependencies
RUN apt update && apt install -y git build-essential libcurl4-openssl-dev wget

# Install ARM cross-toolchain
RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2; tar xf *.bz2
ENV PATH /gcc-arm-none-eabi-9-2019-q4-major/bin:$PATH

# Download OpenGD77 sources
RUN git clone https://github.com/cifred98/OpenGD77.git
WORKDIR OpenGD77

# Build and run binary downloader
RUN cd tools/codec_dat_files_creator && \
    sed -i 's/\/\/#define USE_LIBCURL/#define USE_LIBCURL/' codec_dat_files_creator.c && \
    gcc -Wall -O2 -s `pkg-config libcurl --cflags` -o codec_dat_files_creator \
    codec_dat_files_creator.c -lcurl && \
    ./codec_dat_files_creator && cp codec_bin_section_*.bin ../../firmware/linkerdata

# Build firmware
RUN git checkout -b development origin/development && \
    cd firmware && mkdir build && cd build && ls && make -j9 -f ../Makefile


#
# OpenGD77 Continuous Integration Docker Image
#
FROM debian:latest
MAINTAINER "Niccolò Izzo IU2KIN <n@izzo.sh>"

COPY entrypoint.sh /entrypoint.sh

# Install dependencies
RUN apt update && apt install -y git build-essential libcurl4-openssl-dev wget

# Install ARM cross-toolchain
RUN wget -q https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2; tar xf *.bz2
ENV PATH /gcc-arm-none-eabi-9-2019-q4-major/bin:$PATH

ENTRYPOINT ["/entrypoint.sh"]

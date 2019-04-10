# Build stage
FROM debian:stretch-slim AS build

ENV TMP_PATH /tmp
ENV LIB_NAME libcod2
ENV COD_VER cod2_1_3

# Add i386 architecture support
RUN dpkg --add-architecture i386

# Update system & install 32 bits libraries (needed by cod2_lnxded for gcc 3.3.4 compatibility)
RUN apt update
RUN apt install -y \
  libstdc++5:i386=1:3.3.6-28 \
  libstdc++6:i386=6.3.0-18+deb9u1 \
  curl=7.52.1-5+deb9u9 \
  unzip=6.0-21 \
  gcc-multilib=4:6.3.0-4 \
  g++-multilib=4:6.3.0-4

# Download and extract codlib from "Voron00"
RUN curl -LsSo "${TMP_PATH}/${LIB_NAME}.zip" "https://github.com/voron00/libcod/archive/master.zip"
RUN unzip -j ${TMP_PATH}/${LIB_NAME}.zip -d ${TMP_PATH}/${LIB_NAME}

# Build libcod2 v1.3 (only base lib, no addons)
WORKDIR ${TMP_PATH}/${LIB_NAME}
RUN mkdir -p objects_"${COD_VER}"
ENV constants="-D COD_VERSION=COD2_1_3"
ENV options="-I. -m32 -fPIC -Wall"
RUN g++ $options $constants -c libcod.cpp -o objects_"${COD_VER}"/libcod.opp
# Build libraries
RUN objects="$(ls objects_${COD_VER}/*.opp)"
RUN g++ -m32 -shared -L/lib32 -o /lib/lib"${COD_VER}".so -ldl $objects

# Copy server binary to ensure it is runable
COPY bin/cod2_lnxded_1_3_nodelay_va_loc /bin/cod2_lnxded
RUN chmod +x /bin/cod2_lnxded

# Runtime stage
FROM scratch
LABEL maintainer='bgauduch'

# Copy needed libraries from build stage
COPY --from=build /lib/i386-linux-gnu/ /lib/i386-linux-gnu/
COPY --from=build /usr/lib/i386-linux-gnu/ /usr/lib/i386-linux-gnu/
COPY --from=build /lib/ld-linux.so.2 /lib/ld-linux.so.2
COPY --from=build /lib/libcod2_1_3.so /lib/libcod2_1_3.so

# Copy cod2 server binary from build stage
COPY --from=build /bin/cod2_lnxded /server/cod2_lnxded

# Expose server ports
EXPOSE 20500/udp 20510/udp 28960/tcp 28960/udp

# Set the server dir
WORKDIR /server

# Main files volume metadata
VOLUME [ "/server/main" ]

# Launch server at container startup
ENV LD_PRELOAD="/lib/libcod2_1_3.so"
ENTRYPOINT [ "./cod2_lnxded", "+exec", "config.cfg" ]

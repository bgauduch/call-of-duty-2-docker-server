# Throwaway build stage
FROM debian:stretch-slim AS build

# Configuration
ENV COD2_VER="1_3" \
  LIB_NAME="libcod2" \
  LIBCOD_GIT_URL="https://github.com/voron00/libcod" \
# Choose in: [0 = mysql disables; 1 = default mysql; 2 = VoroN experimental mysql]
  libcod_mysql_type=1

# Add i386 architecture support
RUN dpkg --add-architecture i386

# Update system & install tools
RUN apt update
RUN apt install -y \
  git=1:2.11.0-3+deb9u4
# Install 32 bits c++ libraries needed by cod2_lnxded for gcc 3.3.4 compatibility
RUN apt install -y \
  libstdc++5:i386=1:3.3.6-28 \
  libstdc++6:i386=6.3.0-18+deb9u1 \
  gcc-multilib=4:6.3.0-4 \
  g++-multilib=4:6.3.0-4
# Install mysql 32bit libs required if using libcod mysql
RUN apt install -y \
  libmysql++-dev:i386=3.2.2+pristine-2

# Download codlib from "Voron00"
RUN git clone ${LIBCOD_GIT_URL} ${TMPDIR}/${LIB_NAME}

# Build libcod2
WORKDIR ${TMPDIR}/${LIB_NAME}
RUN yes ${libcod_mysql_type} | ./doit.sh cod2_${COD2_VER}
RUN mv bin/libcod2_${COD2_VER}.so /lib/libcod2_${COD2_VER}.so

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

# Server "main" folder volume
VOLUME [ "/server/main" ]

# Launch server at container startup, using libcod library
ENV LD_PRELOAD="/lib/libcod2_1_3.so"
ENTRYPOINT [ "./cod2_lnxded", "+exec", "config.cfg" ]

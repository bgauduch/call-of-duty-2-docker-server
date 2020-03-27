# Throwaway build stage
FROM debian:buster-20190708-slim AS build

# Configuration
ENV COD2_VER="1_3" \
  LIB_NAME="libcod2" \
  LIBCOD_GIT_URL="https://github.com/voron00/libcod" \
  # Choose in: [0 = mysql disables; 1 = default mysql; 2 = VoroN experimental mysql]
  LIBCOD_MYSQL_TYPE=1

# Add i386 architecture support
RUN dpkg --add-architecture i386

# Install dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates=20190110
RUN apt-get install -y --no-install-recommends git=1:2.20.1-2+deb10u1
# Install 32 bits c++ libraries needed by cod2_lnxded and cross-compilation libs
RUN apt-get install -y --no-install-recommends libstdc++5:i386=1:3.3.6-30
RUN apt-get install -y --no-install-recommends gcc-multilib=4:8.3.0-1
RUN apt-get install -y --no-install-recommends g++-multilib=4:8.3.0-1
# Install mysql & sqlite 32bit libs required if using libcod mysql options
RUN apt-get install -y --no-install-recommends default-libmysqlclient-dev:i386=1.0.5
RUN apt-get install -y --no-install-recommends libsqlite3-dev:i386=3.27.2-3

# Download libcod from "Voron00"
RUN git clone ${LIBCOD_GIT_URL} ${TMPDIR}/${LIB_NAME}

# Build libcod2
WORKDIR ${TMPDIR}/${LIB_NAME}
RUN yes ${LIBCOD_MYSQL_TYPE} | ./doit.sh cod2_${COD2_VER}
RUN mv bin/libcod2_${COD2_VER}.so /lib/libcod2_${COD2_VER}.so

# Copy server binary and make it runable
COPY bin/cod2_lnxded_1_3_nodelay_va_loc /bin/cod2_lnxded
RUN chmod +x /bin/cod2_lnxded

# Copy entrypoint and make it runnable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Runtime stage
FROM alpine:3.11.5
LABEL maintainer='bgauduch'

# Copy needed libraries from build stage
COPY --from=build /lib/i386-linux-gnu/ /lib/i386-linux-gnu/
COPY --from=build /usr/lib/i386-linux-gnu/ /usr/lib/i386-linux-gnu/
COPY --from=build /lib/ld-linux.so.2 /lib/ld-linux.so.2
COPY --from=build /lib/libcod2_1_3.so /lib/libcod2_1_3.so

# Copy cod2 server binary from build stage
COPY --from=build /bin/cod2_lnxded /server/cod2_lnxded

# Copy the entrypoint from build stage
COPY --from=build /entrypoint.sh /entrypoint.sh

# Expose server ports
EXPOSE 20500/udp 20510/udp 28960/tcp 28960/udp

# Set the server dir
WORKDIR /server

# Server "main" folder volume
VOLUME [ "/server/main" ]

# Launch server at container startup, using libcod library
ENTRYPOINT [ "/entrypoint.sh"]
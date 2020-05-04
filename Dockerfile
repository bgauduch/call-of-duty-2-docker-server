# Available build arguments and default configuration
ARG COD2_VERSION
ARG COD2_LNXDED_TYPE
ARG LIBCOD_GIT_URL="https://github.com/voron00/libcod"
# Choose in: [0 = mysql disables; 1 = default mysql; 2 = VoroN experimental mysql]
ARG LIBCOD_MYSQL_TYPE=1

# Throwaway build stage
FROM debian:buster-20190708-slim AS build
ARG COD2_VERSION
ARG COD2_LNXDED_TYPE
ARG LIBCOD_GIT_URL
ARG LIBCOD_MYSQL_TYPE

# Copy server binary and make it runnable
COPY bin/cod2_lnxded_${COD2_VERSION}${COD2_LNXDED_TYPE} /bin/cod2_lnxded
RUN chmod +x /bin/cod2_lnxded

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

# Download and build libcod2 from "Voron00"
RUN git clone ${LIBCOD_GIT_URL} "${TMPDIR}/libcod2"
WORKDIR ${TMPDIR}/libcod2
# hadolint ignore=DL4006
RUN yes ${LIBCOD_MYSQL_TYPE} | ./doit.sh cod2_${COD2_VERSION}
RUN mv bin/libcod2_${COD2_VERSION}.so /lib/libcod2_${COD2_VERSION}.so

# Runtime stage
FROM alpine:3.11.6
ARG COD2_VERSION
LABEL maintainer='bgauduch@github'

# setup the server non-root user
ENV SERVER_USER="cod2"
RUN addgroup -S ${SERVER_USER} && adduser -S -D -G ${SERVER_USER} ${SERVER_USER}
USER ${SERVER_USER}

# Copy needed libraries and binaries
COPY --from=build /usr/lib/i386-linux-gnu/ /usr/lib/i386-linux-gnu/
COPY --from=build /lib/i386-linux-gnu/ /lib/i386-linux-gnu/
COPY --from=build /lib/ld-linux.so.2 /lib/ld-linux.so.2
COPY --from=build /lib/libcod2_${COD2_VERSION}.so /lib/libcod2_${COD2_VERSION}.so
COPY --from=build /bin/cod2_lnxded /home/${SERVER_USER}/cod2_lnxded
COPY lib/pb/v1.760_A1383_C2.208/ /home/${SERVER_USER}/pb/

# Exposed server ports
EXPOSE 20500/udp 20510/udp 28960/tcp 28960/udp

# Server "main" folder volume
VOLUME [ "/home/${SERVER_USER}/main" ]

# Set the server dir
WORKDIR /home/${SERVER_USER}

# redirect server multiplayer logs to container stdout
RUN mkdir -p /home/${SERVER_USER}/.callofduty2/main/ \
  && ln -sf /dev/stdout /home/${SERVER_USER}/.callofduty2/main/games_mp.log

# Launch server at container startup using libcod library
ENV LD_PRELOAD="/lib/libcod2_${COD2_VERSION}.so"
ENTRYPOINT [ "./cod2_lnxded" ]

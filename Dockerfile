# Available build arguments and default configuration
ARG COD2_VERSION
ARG COD2_LNXDED_TYPE
ARG LIBCOD_GIT_URL="https://github.com/voron00/libcod"
# Choose in: [0 = mysql disables; 1 = default mysql; 2 = VoroN experimental mysql]
ARG LIBCOD_MYSQL_TYPE=1

# Throwaway build stage
FROM debian:bookworm-20250929-slim AS build
ARG COD2_VERSION
ARG COD2_LNXDED_TYPE
ARG LIBCOD_GIT_URL
ARG LIBCOD_MYSQL_TYPE
# Define temporary directory for build artifacts
ARG TMPDIR=/tmp

# Copy server binary and make it runnable
COPY bin/cod2_lnxded_${COD2_VERSION}${COD2_LNXDED_TYPE} /bin/cod2_lnxded
RUN chmod +x /bin/cod2_lnxded

# Add i386 architecture support and install dependencies
# hadolint ignore=DL3008
RUN dpkg --add-architecture i386 \
    && apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    # Install 32 bits c++ libraries needed by cod2_lnxded and cross-compilation libs
    libstdc++5:i386 \
    libstdc++6:i386 \
    g++-multilib \
    # Install mysql & sqlite 32bit libs required if using libcod mysql options
    default-libmysqlclient-dev:i386 \
    libsqlite3-dev:i386 \
    && rm -rf /var/lib/apt/lists/*

# Download and build libcod2 from "Voron00"
RUN git clone ${LIBCOD_GIT_URL} "${TMPDIR}/libcod2"
WORKDIR ${TMPDIR}/libcod2
# hadolint ignore=DL4006
RUN yes ${LIBCOD_MYSQL_TYPE} | ./doit.sh cod2_${COD2_VERSION}
RUN mv bin/libcod2_${COD2_VERSION}.so /lib/libcod2_${COD2_VERSION}.so

# Runtime stage
FROM alpine:3.20
ARG COD2_VERSION

# OCI standard labels
LABEL org.opencontainers.image.title="Call of Duty 2 Server"
LABEL org.opencontainers.image.description="Minimal & lightweight containerized Call of Duty 2 multiplayer game server with libcod"
LABEL org.opencontainers.image.authors="Baptiste Gauduchon <bgauduch@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/bgauduch/call-of-duty-2-docker-server"
LABEL org.opencontainers.image.source="https://github.com/bgauduch/call-of-duty-2-docker-server"
LABEL org.opencontainers.image.documentation="https://github.com/bgauduch/call-of-duty-2-docker-server/blob/master/README.md"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.vendor="Baptiste Gauduchon"

# Install netcat for healthcheck
RUN apk add --no-cache netcat-openbsd=1.226-r0

# Create non-root user for running the server
ENV SERVER_USER="cod2"
RUN addgroup -g 1000 ${SERVER_USER} && \
    adduser -D -u 1000 -G ${SERVER_USER} ${SERVER_USER}

# Copy needed libraries and binaries
COPY --from=build /usr/lib/i386-linux-gnu/ /usr/lib/i386-linux-gnu/
COPY --from=build /lib/i386-linux-gnu/ /lib/i386-linux-gnu/
COPY --from=build /lib/ld-linux.so.2 /lib/ld-linux.so.2
COPY --from=build /lib/libcod2_${COD2_VERSION}.so /lib/libcod2_${COD2_VERSION}.so
COPY --chown=${SERVER_USER}:${SERVER_USER} --from=build /bin/cod2_lnxded /home/${SERVER_USER}/cod2_lnxded
COPY --chown=${SERVER_USER}:${SERVER_USER} lib/pb/v1.760_A1383_C2.208/ /home/${SERVER_USER}/pb/

# Exposed server ports
EXPOSE 20500/udp 20510/udp 28960/tcp 28960/udp

# Server "main" folder volume
VOLUME [ "/home/${SERVER_USER}/main" ]

# Set the server dir
WORKDIR /home/${SERVER_USER}

# Redirect server multiplayer logs to container stdout
RUN mkdir -p /home/${SERVER_USER}/.callofduty2/main/ \
  && ln -sf /dev/stdout /home/${SERVER_USER}/.callofduty2/main/games_mp.log \
  && chown -R ${SERVER_USER}:${SERVER_USER} /home/${SERVER_USER}/.callofduty2

# Health checks :
# - check server process is running and responsive
# - check games log are written to file (Uses -e to check symlink/file exists)
HEALTHCHECK --interval=5s --timeout=1s --start-period=5s --retries=3 \
  CMD pgrep -x cod2_lnxded > /dev/null && \
      test -e /home/${SERVER_USER}/.callofduty2/main/games_mp.log || exit 1

# Switch to non-root user
USER ${SERVER_USER}

# Launch server at container startup using libcod library
ENV LD_PRELOAD="/lib/libcod2_${COD2_VERSION}.so"
ENTRYPOINT [ "./cod2_lnxded" ]

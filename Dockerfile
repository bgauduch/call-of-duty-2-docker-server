# Available build arguments and default configuration
ARG COD2_VERSION="1_3"
ARG COD2_LNXDED_TYPE="_nodelay_va_loc"
ARG LIBCOD_TYPE="voron"
# Choose in: [0 = mysql disables; 1 = default mysql; 2 = VoroN experimental mysql]
ARG LIBCOD_MYSQL_TYPE=1
ARG LIBCOD_VORON_VERSION="8e0dee9bf14510c8565e3633b7c0efdf6f9b8a11"
ARG LIBCOD_IBUDDIEAT_VERSION="v14.0"

# ==================================================================
# Base builder with common dependencies
# ==================================================================
FROM debian:bookworm-20250929-slim AS build-base
ARG COD2_VERSION
ARG COD2_LNXDED_TYPE
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

# ==================================================================
# Builder for "voron" libcod
# ==================================================================
FROM build-base AS build-voron
ARG COD2_VERSION
ARG LIBCOD_MYSQL_TYPE
ARG LIBCOD_VORON_VERSION
ARG TMPDIR=/tmp

RUN git clone https://github.com/voron00/libcod "${TMPDIR}/libcod2"
WORKDIR ${TMPDIR}/libcod2
RUN git checkout ${LIBCOD_VORON_VERSION}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Note: doit.sh exits with code 141 (SIGPIPE) when piping yes into it, which is expected behavior
# This specific exit code is catched to allow the build to succeed
RUN yes ${LIBCOD_MYSQL_TYPE} | ./doit.sh cod2_${COD2_VERSION}  || [ $? -eq 141 ]
RUN mv bin/libcod2_${COD2_VERSION}.so /lib/libcod2_${COD2_VERSION}.so

# ==================================================================
# Builder for "ibuddieat" zk_libcod
# ==================================================================
FROM build-base AS build-ibuddieat
ARG COD2_VERSION
ARG LIBCOD_MYSQL_TYPE
ARG LIBCOD_IBUDDIEAT_VERSION
ARG TMPDIR=/tmp

RUN git clone https://github.com/ibuddieat/zk_libcod "${TMPDIR}/libcod2"
WORKDIR ${TMPDIR}/libcod2/code
RUN git checkout ${LIBCOD_IBUDDIEAT_VERSION}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Note: doit.sh exits with code 141 (SIGPIPE) when piping yes into it, which is expected behavior
# This specific exit code is catched to allow the build to succeed
RUN yes ${LIBCOD_MYSQL_TYPE} | ./doit.sh nospeex || [ $? -eq 141 ]
RUN mv bin/libcod2.so /lib/libcod2_${COD2_VERSION}.so

# ==================================================================
# Dynamic build source selector alias
# ==================================================================
# hadolint ignore=DL3006
FROM build-${LIBCOD_TYPE} AS build

# ==================================================================
# Runtime image
# ==================================================================
FROM alpine:3.22
ARG COD2_VERSION

# OCI standard labels
LABEL org.opencontainers.image.title="Call of Duty 2 Server"
LABEL org.opencontainers.image.description="Minimal & lightweight containerized Call of Duty 2 multiplayer game server with libcod"
LABEL org.opencontainers.image.authors="Baptiste Gauduchon <bgauduch@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/bgauduch/call-of-duty-2-docker-server"
LABEL org.opencontainers.image.source="https://github.com/bgauduch/call-of-duty-2-docker-server"
LABEL org.opencontainers.image.documentation="https://github.com/bgauduch/call-of-duty-2-docker-server/blob/main/README.md"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.vendor="Baptiste Gauduchon"

# Create non-root user for running the server
ENV SERVER_USER="cod2"
RUN addgroup -g 1000 ${SERVER_USER} && \
  adduser -D -u 1000 -G ${SERVER_USER} ${SERVER_USER}

# Copy needed libraries and binaries from the selected build stage
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

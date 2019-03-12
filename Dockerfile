# Build Step
FROM debian:stretch-slim AS build
LABEL maintainer='bgauduch'

# Add i386 architecture support
RUN dpkg --add-architecture i386
# Update system & install 32 bits libraries (needed by cod2_lnxded for gcc 3.3.4 compatibility)
RUN apt update
RUN apt install -y libstdc++5:i386

# Minimal runtime setup
FROM scratch

# Copy needed libraries from build stage
COPY --from=build /lib/i386-linux-gnu/ /lib/i386-linux-gnu/
COPY --from=build /usr/lib/i386-linux-gnu/ /usr/lib/i386-linux-gnu/
COPY --from=build /lib/ld-linux.so.2 /lib/ld-linux.so.2

# Expose server ports
EXPOSE 28960/udp 20510/udp

# Set the server dir
WORKDIR /server

# Launch server at container startup
ENTRYPOINT [ "./cod2_lnxded", "+exec", "config.cfg" ]
FROM debian:stretch-slim
LABEL maintainer='bgauduch'

# adding i386 architecture
RUN dpkg --add-architecture i386 && \
# update system & install 32bits libraries (needed for gcc 3.3.4 library use by cod2_lnxded)
	apt-get update && \
	apt-get install -y libstdc++5:i386 && \
# add cod2 user & permissions
	useradd cod2 && \
	mkdir /home/cod2 && \
	chown -R cod2:cod2 /home/cod2 && \
# cleanup
	rm -rf /var/lib/apt/lists /tmp/* && \
	apt-get autoremove -y

# switch to cod2 user
USER cod2

# expose gaming port & master server port
EXPOSE 28960/udp 20510/udp

# launch server
WORKDIR /home/cod2/cod2server
ENTRYPOINT ./cod2_lnxded +exec config.cfg

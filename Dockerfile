FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends libncursesw5 unzip screen && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="template"
ENV GAME_NAME="template"
ENV GAME_PARAMS="template"
ENV GAME_PORT=22003
ENV HTTP_PORT=22005
ENV SKIP_BASECONFIG_CHK=""
ENV DOWNLOAD_RESOURCES="true"
ENV LOGFILE_DIR="multitheftauto_linux_x64/mods/deathmatch/logs/server.txt"
ENV FORCE_UPDATE=""
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID mta && \
	chown -R mta $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && \
	chown -R mta /opt/scripts

USER mta

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]
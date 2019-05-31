FROM ubuntu

MAINTAINER ich777

RUN apt-get update
RUN apt-get -y install wget

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="template"
ENV GAME_NAME="template"
ENV GAME_PARAMS="template"
ENV GAME_PORT=22003
ENV HTTP_PORT=22005
ENV VALIDATE=""
ENV UID=99
ENV GID=100
ENV USERNAME=""
ENV PASSWRD=""

RUN mkdir $DATA_DIR
RUN mkdir $SERVER_DIR
RUN useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID mta
RUN chown -R mta $DATA_DIR

RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/
RUN chown -R mta /opt/scripts

USER mta

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]

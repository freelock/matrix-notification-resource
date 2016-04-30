FROM debian:jessie

RUN apt-get update && apt-get -y install jq curl

COPY bin/ /opt/resource/
COPY matrix_bash_bot/matrix-bashbot.sh /usr/local/bin/
RUN chmod +x /opt/resource/* /usr/local/bin/matrix-bashbot.sh

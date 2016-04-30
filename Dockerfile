FROM debian:jessie

RUN apt-get update && apt-get -y install jq curl

COPY bin/ /opt/resource/
RUN chmod +x /opt/resource/*

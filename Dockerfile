# Infrastructure-as-Code TestKit for Ubuntu
#
# VERSION: 3.2

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update -qq &&\
    apt-get install -qq --no-install-recommends \
        aptitude \
        apt-utils \
        carbon-c-relay &&\
    aptitude full-upgrade -y -q &&\
    apt-get autoremove -qq &&\
    apt-get clean -qq &&\
    aptitude autoclean -y -q &&\
    rm -rf /var/lib/apt/lists/* &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/timezone

ENTRYPOINT [ "/usr/bin/carbon-c-relay", "-f", "/etc/carbon-c-relay/carbon-c-relay.conf" ]

FROM ubuntu:focal as ubuntu-base
### Build essentials
# Set the env base installs
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y update && apt-get install -y \
    tzdata
RUN apt-get install -y \
    locales \
    curl \
    build-essential \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
 && ln -fs /usr/share/zoneinfo/America/Edmonton /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
# Make user
RUN groupadd -g 1000 dock \
 && useradd -m -u 1000 -g dock dock
RUN mkdir /d && chown dock:dock -R /d
RUN mkdir /etc/_conf && chown dock:dock -R /etc/_conf

# vim: set filetype=dockerfile :

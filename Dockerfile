FROM ubuntu:focal as template
### Build essentials
# Set the env base installs
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
    DEBIAN_FRONTEND="noninteractive" apt-get -y update && apt-get install --no-install-recommends -y \
    tzdata \
 && apt-get install --no-install-recommends -y \
    locales \
    curl \
    gpg-agent \
    gpg \
    ca-certificates \
    apt-transport-https \
    build-essential \
    software-properties-common \
    --
RUN ln -fs /usr/share/zoneinfo/America/Edmonton /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && locale-gen en_US.UTF-8 \
 && groupadd -g 1000 dock \
 && useradd -m -u 1000 -g dock dock \
 && mkdir /d && chown dock:dock -R /d \
 && mkdir /etc/_conf && chown dock:dock -R /etc/_conf \
 && chsh -s /usr/bin/zsh dock \
 && mkdir -p /home/dock/.go/bin \
 && chown -R dock:dock /home/dock/.go
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV GOPATH=/home/dock/.go
# Make user

# Add repos
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Add dev stuff
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update -y && apt-get install --no-install-recommends -y \
  python3 \
  python3-pip \
  nodejs \
  docker-ce \
  \
  wget \
  sudo \
  iputils-ping \
  iproute2 \
  git \
  \
  zsh \
  direnv \
  neovim \
  tmux \
  universal-ctags \
  shellcheck \
  --

RUN --mount=type=cache,target=/root/.cache/pip,sharing=locked pip3 install pynvim

# User stuff

# Let entrypoint su to our user

# COPY --from=build-go /opt/go /opt/go
# RUN ln -s /opt/go/bin/go /usr/bin/

# vim: set filetype=dockerfile :

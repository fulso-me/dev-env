FROM ubuntu:focal

# Set the env
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y update && apt-get install -y tzdata locales \
 && ln -fs /usr/share/zoneinfo/America/Edmonton /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get -y update \
 && apt-get install -y \
    build-essential \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    curl \
    wget \
    sudo \
    iproute2 \
    python \
    \
    git \
    zsh \
    direnv \
    neovim \
    tmux \
    universal-ctags \
    nodejs \
    npm \
    yarn \
    --

ENV GOVERSION="1.15.2"
RUN cd /opt && wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
    tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz && \
    ln -s /opt/go/bin/go /usr/bin/

# docker - entrypoint will add us to the external docker group
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
 && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" \
 && apt update \
 && apt install -y docker-ce \
 && curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /bin/docker-compose

# Switch to temporary user
RUN groupadd -g 1000 dock \
 && useradd -m -u 1000 -g dock dock
RUN mkdir /d && chown dock:dock -R /d
RUN mkdir /etc/_conf && chown dock:dock -R /etc/_conf
RUN chsh -s /usr/bin/zsh dock
USER dock
WORKDIR /etc/_conf

# Download gitstatusd so it doesn't redownload on start
# RUN ["/bin/bash", "/bin/zsh -fis <<<'source ~/powerlevel10k/powerlevel10k.zsh-theme'"]
RUN mkdir -p ~/.cache/gitstatus && cd ~/.cache/gitstatus \
 && curl -q -fsSL --output gitstatusd-linux-x86_64.tar.gz -- https://github.com/romkatv/gitstatus/releases/download/v1.0.0/gitstatusd-linux-x86_64.tar.gz \
 && tar -xzf gitstatusd-linux-x86_64.tar.gz

# Install shared tools
RUN go get github.com/mvdan/sh/cmd/shfmt

# Let entrypoint su to our user
USER root

RUN npm install -g bash-language-server \
 && npm install -g dockerfile-language-server-nodejs \
 && apt-get install -y shellcheck

# vim: set filetype=dockerfile :

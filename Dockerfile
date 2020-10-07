### MAIN
FROM ubuntu-base as template
# Add repos
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
 && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Add languages
RUN apt-get update -y && apt-get install -y \
    python \
    nodejs \
    npm \
    docker-ce \
    --
# Add system
RUN apt-get update -y && apt-get install -y \
    wget \
    sudo \
    iputils-ping \
    iproute2 \
    --
# Add dev tools
RUN apt-get update -y && apt-get install -y \
    zsh \
    direnv \
    neovim \
    tmux \
    universal-ctags \
    shellcheck \
    --

# User stuff
RUN chsh -s /usr/bin/zsh dock

# Let entrypoint su to our user
USER root


# COPY --from=build-go /opt/go /opt/go
# RUN ln -s /opt/go/bin/go /usr/bin/
USER dock
RUN mkdir -p /home/dock/.go/bin
ENV GOPATH=/home/dock/.go

USER root

# vim: set filetype=dockerfile :

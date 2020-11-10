FROM ubuntu-npm as build-bash-ls
### Copyable bash-language-server: /usr/local/lib/node_modules & /usr/local/bin/
RUN --mount=type=cache,target=/root/.npm,sharing=locked npm install -g bash-language-server

FROM ubuntu-npm as build-docker-ls
### Copyable docker-language-server: /usr/local/lib/node_modules & /usr/local/bin
RUN --mount=type=cache,target=/root/.npm,sharing=locked npm install -g dockerfile-language-server-nodejs

FROM ubuntu-go as build-shfmt
### Copyable shfmt: /home/dock/.go/bin
RUN --mount=type=cache,target=/root/.cache/go-build,sharing=locked go get github.com/mvdan/sh/cmd/shfmt

FROM ubuntu-npm as build-dots
### Copyable dotfiles: /home/dock
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update -y && apt-get install --no-install-recommends -y \
      build-essential \
      gpg-agent \
      ca-certificates \
      curl \
      wget \
      git \
      npm \
      yarn \
      neovim \
      tmux \
      zsh \
      --
# USER dock
WORKDIR /root
# Force repull
RUN echo 0
RUN git clone --depth=1 https://github.com/fulso-me/devconf.git ._devconf \
 && cd ._devconf \
 && git submodule init \
 && git submodule update --depth=1 \
 && make \
 && tmux start-server \
 && tmux new-session -d \
 && sleep 1 \
 && /root/.tmux/plugins/tpm/bin/install_plugins \
 && tmux kill-server \
 && nvim -u /root/.config/nvim/plugs.vim --headless +'PlugUpdate --sync' +qall
# Install nvim plugs, coc, and fzf

# vim: set filetype=dockerfile :

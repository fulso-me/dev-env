FROM ubuntu-npm as build-bash-ls
### Copyable bash-language-server: /usr/local/lib/node_modules & /usr/local/bin/
RUN npm install -g bash-language-server

FROM ubuntu-npm as build-docker-ls
### Copyable docker-language-server: /usr/local/lib/node_modules & /usr/local/bin
RUN npm install -g dockerfile-language-server-nodejs

FROM ubuntu-go as build-shfmt
### Copyable shfmt: /home/dock/.go/bin
RUN go get github.com/mvdan/sh/cmd/shfmt

FROM ubuntu-npm as build-dots
### Copyable dotfiles: /home/dock
RUN apt-get update -y && apt-get install -y \
      git \
      yarn \
      neovim \
      zsh \
      --
USER dock
WORKDIR /home/dock
RUN git clone --depth=1 https://github.com/fulso-me/devconf.git ._devconf \
 && cd ._devconf \
 && git submodule init \
 && git submodule update --depth=1 \
 && make
# Install nvim plugs, coc, and fzf
RUN nvim -u ~/.config/nvim/plugs.vim --headless +'PlugUpdate --sync' +qall

# vim: set filetype=dockerfile :

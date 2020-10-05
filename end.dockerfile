USER dock

# Increment to force rebuild
RUN echo 0

# Dots
RUN git clone --depth=1 https://github.com/fulso-me/devconf.git ._devconf \
 && cd ._devconf \
 && git submodule init \
 && git submodule update --depth=1 \
 && make

# Install nvim plugs, coc, and fzf
RUN nvim -u ~/.config/nvim/plugs.vim --headless +'PlugUpdate --sync' +qall

USER root

# Clean apt cache
RUN rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh 

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["--help"]
# CMD ["dock", "1000", "dock", "1000", "proj"]

# vim: set filetype=dockerfile :

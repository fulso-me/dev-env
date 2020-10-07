USER root
# Container Copies
COPY --from=build-dots --chown=dock:dock /home/dock /home/dock

COPY --from=build-docker-compose /bin/docker-compose /bin/docker-compose

RUN mkdir -p ~/.cache/gitstatus
COPY --from=build-gitstatusd --chown=dock:dock  /gitstatusd-linux-x86_64 /home/dock/.cache/gitstatus/gitstatusd-linux-x86_64

COPY --from=build-bash-ls /usr/local/lib/node_modules /usr/local/lib/node_modules/
COPY --from=build-bash-ls /usr/local/bin /usr/local/bin/

COPY --from=build-docker-ls /usr/local/lib/node_modules /usr/local/lib/node_modules/
COPY --from=build-docker-ls /usr/local/bin /usr/local/bin/

COPY --from=build-shfmt /home/dock/.go/bin /home/dock/.go/bin/

# Local Copies
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh 

# Clean apt cache
RUN rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["--help"]

# vim: set filetype=dockerfile :


# Clean apt cache
RUN rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh 

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["--help"]
# CMD ["dock", "1000", "dock", "1000", "proj"]

# vim: set filetype=dockerfile :

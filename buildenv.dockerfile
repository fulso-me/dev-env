FROM ubuntu-base as ubuntu-npm
### Npm executable
RUN apt-get update -y && apt-get install -y nodejs npm

FROM ubuntu-base as ubuntu-go
### Go executable
RUN apt-get update -y && apt-get install -y git
COPY --from=build-go /opt/go /opt/go
RUN ln -s /opt/go/bin/go /usr/bin/
RUN mkdir -p /home/dock/.go/bin
ENV GOPATH=/home/dock/.go

# vim: set filetype=dockerfile :

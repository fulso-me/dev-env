FROM alpine as alpine-curl
### Quick curl downloads
RUN apk add --no-cache curl

FROM ubuntu:focal as ubuntu-npm
### Npm executable
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update -y && apt-get install --no-install-recommends -y nodejs npm

FROM ubuntu:focal as ubuntu-go
### Go executable
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update -y && apt-get install --no-install-recommends -y git curl ca-certificates
ENV GOVERSION="1.15.2"
ENV GOPATH=/home/dock/.go
RUN cd /opt && curl -L https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz -o go${GOVERSION}.linux-amd64.tar.gz \
 && tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz \
 && ln -s /opt/go/bin/go /usr/bin/ \
 && mkdir -p /home/dock/.go/bin
# COPY --from=build-go /opt/go /opt/go

# FROM alpine as build-go
# ### Copyable go: /opt/go/bin/go
# ENV GOVERSION="1.15.2"
# RUN cd /opt && wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
#     tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz
#     # ln -s /opt/go/bin/go /usr/bin/

FROM alpine-curl as build-docker-compose
### Copyable docker-compose: /bin/docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /bin/docker-compose \
 && chmod +x /bin/docker-compose

FROM alpine-curl as build-gitstatusd
### Copyable gitstatusd: gitstatusd-linux-x86_64.tar.gz
# RUN ["/bin/bash", "/bin/zsh -fis <<<'source ~/powerlevel10k/powerlevel10k.zsh-theme'"]
WORKDIR /
RUN curl -q -fsSL --output gitstatusd-linux-x86_64.tar.gz -- https://github.com/romkatv/gitstatus/releases/download/v1.0.0/gitstatusd-linux-x86_64.tar.gz \
 && tar -xzf gitstatusd-linux-x86_64.tar.gz

# vim: set filetype=dockerfile :

#!/bin/bash

function compile() {
  echo "# syntax=docker/dockerfile:experimental" > buildcontext/Dockerfile
  # Basic stages for downloading
  cat basics.dockerfile >> buildcontext/Dockerfile
  # Builds for tools
  cat builds.dockerfile >> buildcontext/Dockerfile
  # Base image to use
  cat Dockerfile >> buildcontext/Dockerfile

  cat "$i" >> buildcontext/Dockerfile

  cat end.dockerfile >> buildcontext/Dockerfile

  # cat end.dockerfile >> buildcontext/Dockerfile
  # cat Dockerfile | sed -r -e 's/^#ENVSUBGOESHERE$/RUN apt-get install -y '"$(cat "$i")"'/' > buildcontext/Dockerfile
  # cat buildcontext/Dockerfile
  # if [ "$1" == "clean" ]; then
  # docker build --no-cache buildcontext -t "${ORG}/${NAME}:$(basename "$i")"
  # else
  # docker build buildcontext -t "${ORG}/${NAME}:$(basename "$i")" --target "env-$(basename "${i}")"
  DOCKER_BUILDKIT=1 docker build buildcontext -t "${ORG}/${NAME}:$(basename "$i")"
  # fi
  if [ ! "$?" ]; then
    exit 1
  fi

  echo docker push \""fulsome/${ORG}/${NAME}:$(basename "$i")"\" >> commit.sh
}

ORG="fulsome"
NAME="devenv"

if [ "$1" == "clean" ]; then
  for i in $(docker images | docker images | awk '/^'"${ORG}"'\/'"${NAME}"'/ {print $2}'); do
    docker image rm "${ORG}"/"${NAME}":"$i"
  done
  exit 0
fi

mkdir -p buildcontext
cp entrypoint.sh buildcontext/

echo "#!/bin/bash" > commit.sh
chmod -x commit.sh

if [ -z "$1" ]; then
  for i in envs/*; do
    compile
  done
else
  i=envs/"$1"
  compile
fi

chmod +x commit.sh

rm buildcontext/Dockerfile buildcontext/entrypoint.sh
rmdir buildcontext

#!/bin/bash

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

for i in envs/*; do
  cp main.dockerfile buildcontext/Dockerfile
  if [ -s "$i" ]; then
    cat "$i" >> buildcontext/Dockerfile
    # echo "RUN apt-get install -y $(cat "$i")" >> buildcontext/Dockerfile
  fi
  cat end.dockerfile >> buildcontext/Dockerfile
  # cat Dockerfile | sed -r -e 's/^#ENVSUBGOESHERE$/RUN apt-get install -y '"$(cat "$i")"'/' > buildcontext/Dockerfile
  cat buildcontext/Dockerfile
  if [ "$1" == "clean" ]; then
    docker build --no-cache buildcontext -t "${ORG}/${NAME}:$(basename "$i")"
  else
    docker build buildcontext -t "${ORG}/${NAME}:$(basename "$i")"
  fi
  if [ ! "$?" ]; then
    exit 1
  fi
done

rm buildcontext/Dockerfile buildcontext/entrypoint.sh
rmdir buildcontext

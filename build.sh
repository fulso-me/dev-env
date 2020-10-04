#!/bin/bash

NAME="devenv"

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
  docker build buildcontext -t "fulsome/${NAME}:$(basename "$i")"
  if [ ! "$?" ]; then
    exit 1
  fi
done

rm buildcontext/Dockerfile buildcontext/entrypoint.sh
rmdir buildcontext

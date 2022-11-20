#!/bin/bash

if [[ "$1" == "build" ]]; then
  docker build -t ts10 .
  exit $?
fi

if [[ "$1" == "run" ]]; then
  docker stop ts10 > /dev/null
  docker run -it -d --rm --name ts10 --privileged=true -v "$(pwd)/orig":/orig -v "$(pwd)/patched":/patched ts10
  docker exec -it ts10 /bin/sh
  exit $?
fi

echo \
"./docker.sh <command>

Commands:
  build - build image with scripts
  run   - run interactive shell
"


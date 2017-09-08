#!/usr/bin/env bash

set -e

usage() {
    echo "check.sh --base-dir=<base-dir>"
    echo "         --docker-image=<docker-image>"
}

for i in "$@"; do
    case $i in
    --base-dir=*)
        BASE_DIR="${i#*=}"
        shift
        ;;
    --docker-image=*)
        DOCKER_IMAGE="${i#*=}"
        shift
        ;;
    *)
        usage
        exit 1
        ;;
    esac
done

if [ -z "$BASE_DIR" -o -z "$DOCKER_IMAGE" ]; then
    usage
    exit 1
fi

function check() {
    docker run --volume $BASE_DIR:/library $DOCKER_IMAGE fmt --diff /library
}

exec 5>&1
__diff=$(check | tee >(cat - >&5))

if [ ! -z "$__diff" ]; then
    exit 1
fi

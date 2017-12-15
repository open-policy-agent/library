#!/usr/bin/env bash

set -e

usage() {
    echo "test.sh --base-dir=<base-dir>"
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

docker run --volume $BASE_DIR:/library $DOCKER_IMAGE test --verbose /library

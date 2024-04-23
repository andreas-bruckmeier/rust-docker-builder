#!/usr/bin/env bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
PROJECTPATH="$(pwd)"

# Get binary name using cargo and jq
NAME="$(cargo metadata --no-deps --format-version 1 | jq -r '.packages[].targets[] | select( .kind | map(. == "bin") | any ) | .name')"
VERSION="$(cargo metadata --no-deps --format-version 1 | jq -r '.packages[0] | .version')"

IMAGE_NAME="rust-builder-almalinux-8.8"
CONTAINER_NAME="$IMAGE_NAME-$(date +%s)"
IMAGE_EXISTS="$(docker images -q "$IMAGE_NAME" | wc -l)"

cd $SCRIPTPATH

if [[ $IMAGE_EXISTS -eq 0 || ( -n "$1" && "$1" = "rebuild" ) ]]; then
    docker build \
        --tag "$IMAGE_NAME" \
        --build-arg="BUILD_TIMESTAMP=$(date +%s)" \
        -f almalinux-8.8.dockerfile \
        .
fi

docker run -d --name "$CONTAINER_NAME" \
  -v $PROJECTPATH:/app \
  --env CARGO_TARGET_DIR=/target \
  $IMAGE_NAME \
  /bin/bash -c "echo 'Hello World'; sleep infinity"

docker exec "$CONTAINER_NAME" /root/.cargo/bin/cargo build --release

docker cp \
  "$CONTAINER_NAME:/target/release/$NAME" \
  "$PROJECTPATH/$NAME-almalinux-8.8-$VERSION"

docker rm -f "$CONTAINER_NAME"

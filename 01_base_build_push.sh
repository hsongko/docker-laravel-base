#!/bin/bash
set -o allexport; source ./.env.development; set +o allexport; \
\
sudo docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64 \
\
&& sudo docker logout \
\
&& cat $DOCKERHUB_TOKEN_PATH | sudo docker login --username $DOCKERHUB_USER --password-stdin \
\
&& sudo DOCKER_BUILDKIT=1 DOCKER_CLI_EXPERIMENTAL=enabled \
  docker buildx build \
  --rm \
  --no-cache \
  --push \
  --platform linux/amd64,linux/386,linux/arm64,linux/arm/v7 \
  -t $DOCKERHUB_USER/$BASE_IMAGE_REPO:$BASE_IMAGE_TAG \
  -t $DOCKERHUB_USER/$BASE_IMAGE_REPO:latest \
  -f $BASE_IMAGE_DOCKERFILE . \
\
&& sudo docker logout
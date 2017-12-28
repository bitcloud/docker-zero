#!/bin/sh
GOVERSION=1.8
IMAGE=go-zero
docker build -t $IMAGE -t $IMAGE:$GOVERSION .
echo "DONE $IMAGE:$GOVERSION"
#docker push $IMAGE-$VERSION

#!/bin/sh -e
NETWORK=${NETWORK:-"ezuce"}
docker build $BUILD_FLAGS -t $NETWORK/nginx-ingress .

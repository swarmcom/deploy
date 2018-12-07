#!/bin/sh -e
HUB=${HUB:-"reachme3"}
docker build $BUILD_FLAGS -t $HUB/bar .








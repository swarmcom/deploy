#!/bin/sh -e
HUB=${HUB:-"reach3"}
docker build $BUILD_FLAGS -t $HUB/nginx .

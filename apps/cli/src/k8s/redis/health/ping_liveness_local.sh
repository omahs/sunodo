#!/bin/bash

[[ -f $REDIS_PASSWORD_FILE ]] && export REDIS_PASSWORD="$(< "${REDIS_PASSWORD_FILE}")"
[[ -n "$REDIS_PASSWORD" ]] && export REDISCLI_AUTH="$REDIS_PASSWORD"
response=$(
    timeout -s 15 $1 \
    redis-cli \
    -h localhost \
    -p $REDIS_PORT \
    ping
)
if [ "$?" -eq "124" ]; then
    echo "Timed out"
    exit 1
fi
responseFirstWord=$(echo $response | head -n1 | awk '{print $1;}')
if [ "$response" != "PONG" ] && [ "$responseFirstWord" != "LOADING" ] && [ "$responseFirstWord" != "MASTERDOWN" ]; then
    echo "$response"
    exit 1
fi

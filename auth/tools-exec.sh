#!/bin/sh

# Conditional assembly for container type and platform
if [ "$ALPINE" ]; then
  apk update
else
  apt-get update
fi
if [ "$IMAGEMAGICK_ACTIVE" ]; then
  if [ "$ALPINE" ]; then
    apk add --no-cache imagemagick jpeg
  else
    apt-get install -y imagemagick jpeg
  fi
fi
if [ "$UPGRADE" ]; then
  if [ "$ALPINE" ]; then
    apk add --upgrade apk-tools && apk upgrade --available
  else
    apt-get upgrade -y
  fi
fi

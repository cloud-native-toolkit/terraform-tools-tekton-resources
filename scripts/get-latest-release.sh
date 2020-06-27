#!/usr/bin/env bash

GIT_URL="$1"
RELEASE="$2"

if [[ "${RELEASE}" == "latest" ]]; then
  LATEST_RELEASE=$(curl -s "${GIT_URL}/releases/latest" | grep tag_name | sed -E "s/.*\"tag_name\": \"(.*)\".*/\1/")
  echo -n "${LATEST_RELEASE}"
else
  echo -n "${RELEASE}"
fi

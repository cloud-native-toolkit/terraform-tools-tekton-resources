#!/usr/bin/env bash

GIT_URL="$1"
RELEASE="$2"
OUT_FILE="$3"

if [[ "${RELEASE}" == "latest" ]]; then
  LATEST_RELEASE=$(curl -s "${GIT_URL}/releases/latest" | grep tag_name | sed -E "s/.*\"tag_name\": \"(.*)\".*/\1/")
  echo "Latest release: ${LATEST_RELEASE}"
  echo -n "${LATEST_RELEASE}" > "${OUT_FILE}"
else
  echo "Release: ${RELEASE}"
  echo -n "${RELEASE}" > "${OUT_FILE}"
fi

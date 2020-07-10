#!/usr/bin/env bash

GIT_URL="$1"
RELEASE="$2"
OUT_FILE="$3"

if [[ -z "${GIT_URL}" ]]; then
  echo "The GIT_URL is required as the first argument"
  exit 1
fi

if [[ -z "${RELEASE}" ]]; then
  echo "The RELEASE is required as the second argument"
  exit 1
fi

if [[ -z "${OUT_FILE}" ]]; then
  echo "The OUT_FILE is required as the third argument"
  exit 1
fi

set -e

BASE_DIR=$(dirname "${OUT_FILE}")
echo "Creating directory for outfile - ${BASE_DIR}"
mkdir -p "${BASE_DIR}"

if [[ "${RELEASE}" == "latest" ]]; then
  LATEST_RELEASE=$(curl -s "${GIT_URL}/releases/latest" | grep tag_name | sed -E "s/.*\"tag_name\": \"(.*)\".*/\1/")
  echo "Latest release: ${LATEST_RELEASE}"
  echo -n "${LATEST_RELEASE}" > "${OUT_FILE}"
else
  echo "Release: ${RELEASE}"
  echo -n "${RELEASE}" > "${OUT_FILE}"
fi

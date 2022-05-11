#!/usr/bin/env bash

INPUT=$(tee)

BIN_DIR=$(echo "${INPUT}" | grep "bin_dir" | sed -E 's/.*"bin_dir": ?"([^"]*)".*/\1/g')

export PATH="${BIN_DIR}:${PATH}"

GIT_URL=$(echo "${INPUT}" | jq -r '.git_url // empty')
RELEASE=$(echo "${INPUT}" | jq -r '.revision // empty')

if [[ -z "${GIT_URL}" ]]; then
  echo "The GIT_URL is required" >&2
  exit 1
fi

if [[ -z "${RELEASE}" ]]; then
  echo "The RELEASE is required" >&2
  exit 1
fi

set -e

if [[ "${RELEASE}" == "latest" ]]; then
  RELEASE=$(curl -s "${GIT_URL}/releases/latest" | jq -r '.tag_name')
fi

jq -n --arg RELEASE "${RELEASE}" '{"release": $RELEASE}'

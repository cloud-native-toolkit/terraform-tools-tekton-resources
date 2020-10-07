#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
REPO_DIR=$(cd ${SCRIPT_DIR}/../..; pwd -P)

if [[ -n "$GITHUB_USERNAME" ]] && [[ -n "$GITHUB_TOKEN" ]]; then
  GITHUB_AUTH="-u ${GITHUB_USERNAME}:${GITHUB_TOKEN}"
fi

set -e

git_slug="IBM/ibm-garage-tekton-tasks"

git_release_url="https://api.github.com/repos/${git_slug}/releases/latest"

latest_release=$(curl ${GITHUB_AUTH} -s "${git_release_url}" | grep tag_name | sed -E "s/.*\"tag_name\": \"(.*)\".*/\1/")

if [[ -n "${latest_release}" ]]; then
  echo "  ++ Latest release for ${git_slug} is ${latest_release}"

  current_release=$(cat "${REPO_DIR}/variables.tf" | grep -A 3 'variable "revision"' | grep "default" | sed -E "s/ +default += \"(.*)\"/\1/g")

  sed "s/${current_release}/${latest_release}/g" "${REPO_DIR}/variables.tf" > "${REPO_DIR}/variables.tf.bak" && \
      cp "${REPO_DIR}/variables.tf.bak" "${REPO_DIR}/variables.tf" && \
      rm "${REPO_DIR}/variables.tf.bak"
else
  echo "  ** Release not found for ${git_release_url}"
fi

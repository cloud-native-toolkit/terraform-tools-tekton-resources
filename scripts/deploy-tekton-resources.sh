#!/usr/bin/env bash

NAMESPACE="$1"
PRE_TEKTON="$2"
REVISION="$3"
GIT_URL="$4"

if [[ -n "${BIN_DIR}" ]]; then
  export PATH="${BIN_DIR}:${PATH}"
fi

if [[ -n "${KUBECONFIG_IKS}" ]]; then
    export KUBECONFIG="${KUBECONFIG_IKS}"
fi

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR=./.tmp
fi
mkdir -p "${TMP_DIR}"

URL=$(curl -s "${GIT_URL}/releases/tags/${REVISION}" | grep release.yaml | grep browser_download_url | sed -E 's/.*"(https:.*)"/\1/g')
echo "Tekton task url: ${URL}"

echo "*** Waiting for Tekton API group to be available"
until kubectl get tasks
do
    echo '>>> waiting for Tekton APIs availability'
    sleep 60
done
echo '>>> Tekton APIs are available'

kubectl apply -n "${NAMESPACE}" -f "${URL}"

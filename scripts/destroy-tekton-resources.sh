#!/usr/bin/env bash

NAMESPACE="$1"
REVISION="$2"

if [[ -n "${KUBECONFIG_IKS}" ]]; then
    export KUBECONFIG="${KUBECONFIG_IKS}"
fi

kubectl delete tasks -l "version=${REVISION}" -n "${NAMESPACE}" || true
kubectl delete pipelines -l "version=${REVISION}" -n "${NAMESPACE}" || true

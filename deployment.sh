#!/bin/bash

set -e

BASEDIR=$(dirname "$(readlink -f -- "$0")")
cd "${BASEDIR}" || exit

source "${BASEDIR}"/.env

# Define Kubernetes cluster directory
KUBERNETES_CLUSTER_DIRECTORY="${BASEDIR}"/kubernetes-cluster

printf 'Clone Kubernetes cluster repository.\n'
rm -rf "${KUBERNETES_CLUSTER_DIRECTORY}"
if [ ${GH_TOKEN} ]; then
    git clone https://paretl:${GH_TOKEN}@github.com/MyCarbonFootprint/kubernetes-cluster.git "${KUBERNETES_CLUSTER_DIRECTORY}"
else
    git clone git@github.com:MyCarbonFootprint/kubernetes-cluster.git "${KUBERNETES_CLUSTER_DIRECTORY}"
fi

printf 'Get Kube config file.\n'
cd "${KUBERNETES_CLUSTER_DIRECTORY}"
terraform init
terraform apply -target local_file.kubeconfig -auto-approve
mv "${KUBERNETES_CLUSTER_DIRECTORY}"/kubeconfig "${BASEDIR}"/kubeconfig
chmod 600 "${BASEDIR}"/kubeconfig
export KUBECONFIG="${BASEDIR}"/kubeconfig
rm -rf "${KUBERNETES_CLUSTER_DIRECTORY}"
cd "${BASEDIR}"

printf 'Check cluster connection.\n'
# Check cluster connexion
kubectl cluster-info

printf 'Deploy mariadb.\n'
# Add helm repo
helm repo add bitnami https://charts.bitnami.com/bitnami
# define release name
HELM_RELEASE_NAME="mariadb-release"
# Define helm parameters
HELM_PARAMS="--namespace dev \
-f "${BASEDIR}"/values.yaml \
${HELM_RELEASE_NAME} \
--set auth.rootPassword=${MARIADB_ROOT_PASSWORD} \
bitnami/mariadb"

# check if the helm is already created, install or upgrade it
if [[ $(helm -n dev list | grep ${HELM_RELEASE_NAME}) == '' ]]; then
    helm install \
        ${HELM_PARAMS}
else
    helm upgrade \
        ${HELM_PARAMS}
fi

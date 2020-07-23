#!/bin/bash
# --------------------------------------------------------------------------------------------------------
# Name : Create Edge Access Secret for use in CI/CD Pipeline in Development Cluster
#
# Log into Edge Cluster and run this script
#
# Once Secret has been create apply the secret to you development project/namespace
#
# Author : Matthew Perrins mjperrin@us.ibm.com
# --------------------------------------------------------------------------------------------------------
#
# input validation

# Extract the Core meta data for
export HZN_EXCHANGE_URL=https://$(oc get routes icp-console -o jsonpath='{.spec.host}' -n kube-system)/edge-exchange/v1
export EXCHANGE_ROOT_PASS=$(oc -n kube-system get secret ibm-edge-auth -o jsonpath="{.data.exchange-root-pass}" | base64 --decode)
export HZN_EXCHANGE_USER_AUTH="root/root:$EXCHANGE_ROOT_PASS"
export HZN_ORG_ID=IBM

# Extra the Certificate Authority Certificate
oc --namespace kube-system get secret cluster-ca-cert -o jsonpath="{.data['tls\.crt']}" | base64 --decode > /tmp/icp-ca.crt

# Create the Secret
kubectl create secret generic edge-access \
  --from-literal=HZN_EXCHANGE_URL=$HZN_EXCHANGE_URL \
  --from-literal=HZN_EXCHANGE_USER_AUTH=$HZN_EXCHANGE_USER_AUTH \
  --from-literal=HZN_ORG_ID=$HZN_ORG_ID \
  --from-file=HZN_CERTIFICATE=/tmp/icp-ca.crt -o yaml --dry-run | \
kubectl label -f - --dry-run --local -o yaml --local \
  group=catalyst-tools \
  grouping=garage-cloud-native-toolkit  > edge-access-secret.yaml

echo "Completed creating the edge-access-security.yaml ..."
#!/usr/bin/bash

helm repo add \
crossplane-stable https://charts.crossplane.io/stable && helm repo update
helm install crossplane \
crossplane-stable/crossplane \
--namespace crossplane-system \
--create-namespace

kubectl get pods -n crossplane-system
# Look at the new API end-points with kubectl api-resources
kubectl api-resources  | grep crossplane

# Create a Kubernetes secret for AWS 
# Create a text file containing the AWS account aws_access_key_id and aws_secret_access_key.

kubectl create secret \
generic aws-secret \
-n crossplane-system \
--from-file=creds=./aws-credentials.txt

# Check the secret
kubectl describe secret

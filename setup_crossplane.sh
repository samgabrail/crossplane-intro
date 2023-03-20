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

# Install the AWS provider 

cat <<EOF | kubectl apply -f -
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: upbound-provider-aws
spec:
  package: xpkg.upbound.io/upbound/provider-aws:v0.27.0
EOF

# It may take up to five minutes for the provider to list HEALTHY as True.

kubectl get providers

# Create a Kubernetes secret for AWS 
# Create a text file containing the AWS account aws_access_key_id and aws_secret_access_key.

kubectl create secret \
generic aws-secret \
-n crossplane-system \
--from-file=creds=./aws-credentials.txt

# Create a ProviderConfig 
# A ProviderConfig customizes the settings of the AWS Provider.

cat <<EOF | kubectl apply -f -
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: aws-secret
      key: creds
EOF

# Create an S3 managed resource 

cat <<EOF | kubectl create -f -
apiVersion: s3.aws.upbound.io/v1beta1
kind: Bucket
metadata:
  name: tekanaid-crossplane
  labels:
    docs.crossplane.io/example: provider-aws
spec:
  forProvider:
    region: us-east-1
  providerConfigRef:
    name: default
EOF


kubectl get buckets

# Delete the managed resource 

kubectl delete bucket --selector=docs.crossplane.io/example=provider-aws


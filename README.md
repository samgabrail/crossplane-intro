# crossplane-intro
Intro to Crossplane


## Step 1: Install Crossplane

Let's use helm to install crossplane:

```bash
helm repo add \
crossplane-stable https://charts.crossplane.io/stable && helm repo update

helm install crossplane \
crossplane-stable/crossplane \
--namespace crossplane-system \
--create-namespace
```

Check that the pods came up

```bash
kubectl get pods -n crossplane-system
```

Look at the new API end-points with kubectl api-resources

```bash
kubectl api-resources  | grep crossplane
```

## Step 2: Create a Kubernetes secret for AWS 

Rename the `aws-credentials-example.txt` file to `aws-credentials.txt` and add your AWS credentials to the file. Make sure you don't check this file into git.

Now create the secret below

```bash
kubectl create secret \
generic aws-secret \
-n crossplane-system \
--from-file=creds=./aws-credentials.txt
```

Check that the secret was created:
```bash
kubectl describe secret aws-secret
```

> Note that if your AWS creds change, you can delete this secret and recreate it after updating your `aws-credentials.txt` file. Make sure you don't check this file into git.

## Step 3: Get the AWS provider and provider config ready

Now let's configure the AWS provider and use the credentials we created.

```bash
kubectl apply -f provider.yaml
```

You now have your Kubernetes cluster ready with crossplane installed.

## Step 4: Define S3 Bucket Resource Class
Create a file named s3bucketclass.yaml with the following content:

```yaml
apiVersion: aws.crossplane.io/v1beta1
kind: BucketClass
metadata:
  name: s3bucket-standard
spec:
  deletionPolicy: Delete
  providerConfigRef:
    name: default
  region: us-east-1
  cannedACL: private
  versioning:
    status: Enabled
```

Apply the configuration:

```bash
kubectl apply -f s3bucketclass.yaml
```

Step 5: Create a Resource Claim
Create a file named bucketclaim.yaml with the following content:

```yaml
apiVersion: storage.crossplane.io/v1alpha1
kind: Bucket
metadata:
  name: sample-bucket
spec:
  classSelector:
    matchLabels:
      tier: standard
  writeConnectionSecretToRef:
    name: bucketsecret
```

Apply the configuration:

```bash
kubectl apply -f bucketclaim.yaml
```

## Step 6: Verify Resource Status
Check the status of the resource claim to ensure the S3 bucket has been successfully provisioned:

```bash
kubectl get buckets.storage.crossplane.io sample-bucket -o wide
```

Upon successful provisioning, you should see Bound under the STATUS column.

## Conclusion

In this demo, we walked through the process of creating an AWS S3 bucket using Crossplane. This showcases how Crossplane facilitates cloud resource provisioning through a declarative API, abstracting the complexities of individual cloud providers and providing a unified, Kubernetes-native interface for cloud infrastructure management.
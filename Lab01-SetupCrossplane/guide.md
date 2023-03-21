# Setup Crossplane

In this lab we will set up crossplane. We don't go over the steps of creating a Kubernetes cluster. Please create one with at least 6 GB of memory available. My recommendation is to use, minikube, KIND, or Docker Desktop. I personally use Docker Desktop on WSL2 on my Windows computer.

## Install Crossplane

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

## Create a Kubernetes secret for AWS 

Rename the `aws-credentials-example.txt` file to `aws-credentials.txt` and add your AWS credentials to the file.

Now create the secret below

```bash
kubectl create secret \
generic aws-secret \
-n crossplane-system \
--from-file=creds=./aws-credentials.txt
```

Check that the secret was created:
```bash
kubectl describe secret
```

> Note that if your AWS creds change, you can delete this secret and recreate it after updating your `aws-credentials.txt` file. Make sure you don't check this file into git.

## Get the AWS provider and provider config ready

Now let's configure the AWS provider and use the credentials we created.

```bash
kubectl apply -f provider.yaml
```

You now have your Kubernetes cluster ready with crossplane installed. You are now ready to proceed to the next lab.

> This is the end of the lab.
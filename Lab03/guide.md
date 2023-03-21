# ArgoCD Setup

In this lab we will get ArgoCD ready for crossplane.

## Install ArgoCD

### Install the ArgoCD Server

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Wait until all the pods are running

```bash
watch kubectl get po
```

## Access ArgoCD

### Expose the ArgoCD API Server

```bash
kubectl port-forward svc/argocd-server -n argocd 8002:443
```

### Get the admin password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

For this lab, I won't change the password, but you should go ahead and change the password and remove the K8s secret.

### Login using the CLI and/or the UI

To login using the CLI:

```bash
argocd login 127.0.0.1:8002
```

Answer `y` to the cert validation warning, then use
username: admin
password: <THE_PASSWORD_YOU_GOT_ABOVE>

You can also log in to the UI by opening a browser window and going to https://127.0.0.1:8002

## Create the School App Application in ArgoCD

```bash
kubectl apply -f argoCDcrossplane.yaml
```

## Test the School App with Hardcoded Secrets

```bash
# Port forward the frontend
kubectl port-forward service/frontend 8001:8080 -n schoolapp
# Port forward the api
kubectl port-forward service/api 5000:5000 -n schoolapp
```

Try creating and deleting a course and check the logs of the api pod.

```bash
kubectl logs -n schoolapp -f $(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{end}}' --selector=app=api) -c api
```

Notice this output:

**Expected Output**
```
MongoDB Credentials Using Hardcoded Values that appear in GitLab: 
Username = schoolapp
Password = mongoRootPass
```

This was using the hardcoded values, next let's try with the injector

> This concludes this lab
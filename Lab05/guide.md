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

### Login using the UI

You can also log in to the UI by opening a browser window and going to https://127.0.0.1:8002
username: admin
password: <THE_PASSWORD_YOU_GOT_ABOVE>


### Configure Private Repos

You can skip this step if you're using a public repo.

Go to Settings > Repositories and click on `CONNECT REPO`.

You can choose from a few cononection methods. I used the SSH method.
Add your Repository URL using the `git@github.com` prefix like this: `git@github.com:samgabrail/crossplane-intro.git`
Add your SSH private key that you use with GitHub.
Then click the `CONNECT` button at the top.

## Create the School App Application in ArgoCD

```bash
kubectl apply -f argoCDcrossplane.yaml
```

Notice in the `argoCDcrossplane.yaml` file how the repo is referenced using the `git@github.com` prefix like this: `git@github.com:samgabrail/crossplane-intro.git`. This is because we're using a private repo. For a public repo, you would reference it via `https` like this: `https://github.com/samgabrail/crossplane-intro.git`

Click the `APP DIFF` button to see the diff in the different resources that will get created. Then click the `SYNC` button and then the `SYNCHRONIZE` button.
Wait until all the resources are up.

Then click on the instance and go to the `LIVE MANIFEST` tab where you will see an output similar to the one below. You will find the `publicIp` of the instance. Open a new browser tab and insert the `publicIp` address to see the school app deployed.

```bash
status:
  atProvider:
    arn: 'arn:aws:ec2:us-east-1:047709130171:instance/i-0c780910ded22005d'
    id: i-0c780910ded22005d
    instanceState: running
    outpostArn: ''
    passwordData: ''
    primaryNetworkInterfaceId: eni-06dc143f13e446165
    privateDns: ip-192-168-1-13.ec2.internal
    publicDns: ec2-3-86-95-159.compute-1.amazonaws.com
    publicIp: 3.86.95.159
```

## Change a tag value in the repo

You can try changing the EC2 instance tag in the `ec2.yaml` file from `environment: dev` to `environment: qa`. Then commit and push the changes. You can wait for about 5 minutes, or in the ArgoCD UI, click the `REFRESH APPS` button. You will see that we are out of sync. Go ahead and sync. You can then check the AWS console to see that the tag has been changed.

```yaml
    tags:
      Name: tekanaid-sample-instance
      environment: qa
```

## Clean up

In the ArgoCD dashboard you can click the 3 dots beside the app and click delete to delete the application. You will then need to confirm the deletion by typing the name of the application. This will destroy all the resources from AWS.
# Build Networking

In this lab we will revisit our EC2 instance and instead of using the default VPC, we will build some networking for a new VPC and spin up our web server in it.

## Networking Folder

Examine the networking folder to see 3 yaml files corresponding to the necessary networking resources to be created.

`igw_rt.yaml:` Here we create an Internet Gateway with a Routing Table
`subnets:` Here we create subnets
`vpc:` Here we create a VPC

Notice how we reference different resources via id such as 
```yaml
    vpcIdRef:
      name: development-vpc
```

## Deploy the Instance with Networking

```bash
kubectl apply -f instance
kubectl apply -f networking
```

Wait till the EC2 instance is ready by running this command:

```bash
watch kubectl get instance.ec2
```

To get the public IP address, you can describe the instance:
```bash
kubectl describe instance.ec2
```

You can also check the networking resources you created:
```bash
kubectl get vpc
kubectl get subnet
kubectl get routetable
kubectl get route
kubectl get internetgateway
```

Now you can ssh into the EC2 instance like this:

```bash
ssh -i mykey ubuntu@publicIP
```

You can also view the webserver by going to the public IP in an browser window.

Congratulations, you created an instance with its own networking with crossplane!

> This is the end of the lab.
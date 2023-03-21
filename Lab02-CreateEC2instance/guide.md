# Create a simple EC2 Instance

In this lab we will create a simple EC2 instance with crossplane.

## Create an EC2 Instance

Now that we have crossplane set up, let's create an EC2 instance.

Examine the `ec2.yaml` file then run the following command from the `Lab02` directory:

```bash
kubectl apply -f instance
```

Wait till the EC2 instance is ready by running this command:

```bash
watch kubectl get instance.ec2
```

Once it's ready you can check to see that the instance was created in the default VPC. Check it in your AWS console. We can't do much with this instance since there are no security groups defined and we can't even SSH into it since we didn't define create a key pair. We will see this in our next lab.

> This is the end of the lab.
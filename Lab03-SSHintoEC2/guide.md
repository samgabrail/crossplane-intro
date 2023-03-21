# SSH into the EC2 Instance

In this lab we will revisit our EC2 instance and see how to SSH into it by creating a key pair and a security group.

## Create a Key Pair

Examine the `ec2.yaml` file and notice the new `KeyPair` resource. You will need to supply your own `publicKey` to be used to ssh into the EC2 instance. You probably have one already generated on your machine under the `.ssh` directory in your `home` directory.

If you don't and would like to create one then use the following:

ssh-keygen -t rsa -b 4096 -f ./Lab03-SSHintoEC2/mykey

> I've already created one here that you can use. Make sure you don't push your private key to git.

## Create a Security Group

Examine the `securitygroup.yaml` file and notice how you create a security group then you create security group rules that reference this security group. There are a few ways to reference, below we use the `securityGroupIdSelector` with a `matchLabels` of `selector: my-security-group`. This label is added to the security group label section.

```yaml
    securityGroupIdSelector:
      matchLabels:
        selector: my-security-group
```

## Deploy the Instance and Security Group

```bash
kubectl apply -f instance
```

Wait till the EC2 instance is ready by running this command:

```bash
watch kubectl get instance.ec2
```

To get the public IP address, you can describe the instance:
```bash
kubectl describe instance.ec2
```

You can also check the security group by running:
```bash
kubectl get securitygroup
```

Now you can ssh into the EC2 instance like this:

```bash
ssh -i mykey ubuntu@publicIP
```

Congratulations, you created an instance with a key pair and a security group and were able to ssh into it!

> This is the end of the lab.
# Build a WebServer with User Data

In this lab we will revisit our EC2 instance and create an NGINX web server using User Data.

## User Data Script

Examine the `user_data.sh` file. This is the script that will get passed to the EC2 instance as it gets created. It will run an NGINX server.

## Create a base64 encoded string of the user_data file

To feed user data into our `ec2.yaml` file, we need to first base64 encode the `user_data.sh` file. To do so, run the command below:

```bash
cat crossplane_example/instance/user_data.sh | base64 -w 0
```

Then notice the `userDataBase64` field in the `ec2.yaml` and the `Instance` resource:

```yaml
    userDataBase64: IyEvYmluL2Jhc2gKZWNobyAiSW5zdGFsbGluZyB0cmVlLCBqcSwgYW5kIG5naW54IgphcHQgLXkgdXBkYXRlCmFwdCBpbnN0YWxsIHRyZWUganEgLXkKYXB0IGluc3RhbGwgbmdpbnggLXkKc3lzdGVtY3RsIGVuYWJsZSBuZ2lueApleHBvcnQgcHJpdmF0ZUlQPSQoY3VybCBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvbG9jYWwtaXB2NCkKZXhwb3J0IGluc3RhbmNlSUQ9JChlYzJtZXRhZGF0YSAtLWluc3RhbmNlLWlkKQpzdWRvIGNhdCA8PCBFT0YgPiAvdG1wL2luZGV4Lmh0bWwKPGh0bWw+CiAgICA8aGVhZD4KICAgICAgICA8dGl0bGU+U2Nob29sYXBwPC90aXRsZT4KICAgIDwvaGVhZD4KICAgIDxib2R5PgogICAgICAgIDxoMSBzdHlsZT0idGV4dC1hbGlnbjogY2VudGVyOyI+V2VsY29tZSB0byB0aGUgU2Nob29sIEFwcDwvaDE+CiAgICAgICAgPHAgc3R5bGU9InRleHQtYWxpZ246IGNlbnRlcjsiPgogICAgICAgIDxpbWcgc3JjPSJodHRwczovL2ltYWdlcy51bnNwbGFzaC5jb20vcGhvdG8tMTUwODgzMDUyNDI4OS0wYWRjYmU4MjJiNDA/aXhsaWI9cmItMS4yLjEmaXhpZD1Nbnd4TWpBM2ZEQjhNSHh3YUc5MGJ5MXdZV2RsZkh4OGZHVnVmREI4Zkh4OCZhdXRvPWZvcm1hdCZmaXQ9Y3JvcCZ3PTYwMCZxPTgwIiBhbHQ9IlNjaG9vbCBBcHAiPgogICAgICAgIDwvcD4KICAgICAgICA8cCBzdHlsZT0idGV4dC1hbGlnbjogY2VudGVyOyI+CiAgICAgICAgUGhvdG8gYnkgPGEgaHJlZj0iaHR0cHM6Ly91bnNwbGFzaC5jb20vQGFsdHVtY29kZT91dG1fc291cmNlPXVuc3BsYXNoJnV0bV9tZWRpdW09cmVmZXJyYWwmdXRtX2NvbnRlbnQ9Y3JlZGl0Q29weVRleHQiPkFsdHVtQ29kZTwvYT4gb24gPGEgaHJlZj0iaHR0cHM6Ly91bnNwbGFzaC5jb20vcy9waG90b3MvY291cnNlcz91dG1fc291cmNlPXVuc3BsYXNoJnV0bV9tZWRpdW09cmVmZXJyYWwmdXRtX2NvbnRlbnQ9Y3JlZGl0Q29weVRleHQiPlVuc3BsYXNoPC9hPgogICAgICAgIDwvcD4KICAgICAgICA8aDIgc3R5bGU9InRleHQtYWxpZ246IGNlbnRlcjsiPlRoaXMgbWVzc2FnZSBjb25maXJtcyB0aGF0IHlvdXIgQXBwIGlzIHdvcmtpbmcgd2l0aCBhbiBOR0lOWCB3ZWIgc2VydmVyLiBHcmVhdCB3b3JrITwvaDI+CiAgICAgICAgPGgyIHN0eWxlPSJ0ZXh0LWFsaWduOiBjZW50ZXI7Ij5HcmVldGluZ3MgZnJvbSBFQzIgaW5zdGFuY2UgJGluc3RhbmNlSUQgd2l0aCBwcml2YXRlIElQOiAkcHJpdmF0ZUlQPC9oMj4KICAgIDwvYm9keT4KPC9odG1sPgpFT0YKc3VkbyBtdiAvdG1wL2luZGV4Lmh0bWwgL3Zhci93d3cvaHRtbC9pbmRleC5odG1sCnN1ZG8gbmdpbnggLXMgcmVsb2Fk
```

## Update to the security group

Notice that we added port 80 to the `SecurityGroupRule` in the `securitygroup.yaml` file. This allows us to access the web server.

```yaml
apiVersion: ec2.aws.upbound.io/v1beta1
kind: SecurityGroupRule
metadata:
  name: http-vpc-securitygroup-ingress
spec:
  deletionPolicy: Delete
  forProvider:
    cidrBlocks:
      - 0.0.0.0/0
    fromPort: 80
    protocol: tcp
    region: us-east-1
    securityGroupIdSelector:
      matchLabels:
        selector: my-security-group
    toPort: 80
    type: ingress
  providerConfigRef:
    name: awsconfig
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

Now open your browser and put in the public IP address to view your new and shiny web server!

Congratulations, you created a web server using crossplane!

> This is the end of the lab.
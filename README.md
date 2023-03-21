# crossplane-intro
Introduction to Crossplane

## Create a base64 encoded string of the user_data file
```bash
cat crossplane_example/instance/user_data.sh | base64 -w 0
```
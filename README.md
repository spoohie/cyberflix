# cyberflix

![Architecture overview](https://user-images.githubusercontent.com/13929718/126980722-69148de6-bc30-4b74-85c0-479e012b3241.png)

AWS-based serverless VOD platform, written for learning purpouses.

## Installation 

#### Build FaceBlurer environment

Execute all Terraform commands from the `infrastructure` directory.

1. Create Terraform workspace

```
terraform workspace new $workspace_name
terraform workspace select $workspace_name
```

2. Init Terraform project

```
terraform init
```

3. Apply Terraform project to AWS

```
terraform apply --auto-approve
```

**Destroy environment:**

```
terraform destroy --auto-approve
```

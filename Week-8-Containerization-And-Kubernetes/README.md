# Week 8 - Containerization and Kubernetes

This week we will take a close look on how to run containers in Azure and AWS.
Based on the workflow showed in the Cloud Native Bootcamp videos I created an alternative way in which we deploy all our workload with terraform.

_Note:_ If you are looking for a good and handy GUI/IDE for administrating/developing on k8s clusters you should have a look at [Lens](https://k8slens.dev/).

## Project 1 - Creating a Minikube environment

In this project we will create a local Minikube installation which can be used for local development.

### Software (Minikube)

| Name     | Installation Method | Install Command          |
| -------- | ------------------- | ------------------------ |
| Minikube | Chocolatey          | `choco install minikube` |

### Create Deployment

After instaling minikube you should be able to to run one of the following commands from the Week 8 root directory to start the deployment:

```Powershell
kubectl create -f nginx.yml
```

```Powershell
kubectl apply -f nginx.yml
```

_Note:_ In terms of creation `kubectl create` will do the same as `kubectl apply`. But the later will also apply changes should you modify the YAML and want to change the running deployment.

### Check Deployments

With the following command you can check the status of your deployments within the default namespace:

```Powershell
kubectl get deployments
```

### Check Pods

With the following command you can check the status of all your pods within the default namespace:

```Powershell
kubectl get pods
```

### Alternative to Minikube

As an alternative to Minikube I normally use Docker Desktop which has an easy to install Kubernetes option.
And since you need Docker anyways on Windows to run your containers, we can also use its integrated Kubernetes (k8s).

#### Software (Docker)

| Name           | Installation Method | Install Command                |
| -------------- | ------------------- | ------------------------------ |
| Docker Desktop | Chocolatey          | `choco install docker-desktop` |
| K8s CLI        | Chocolatey          | `choco install kubernetes-cli` |

## Project 2 - Creating an AKS Cluster

This project will show you two ways of how to create an AKS cluster.

1. Via Powershell script using the AZ module
2. Using terraform

### Create AKS with Powershell

#### Software (Create AKS with Powershell)

| Name                     | Installation Method           | Install Command                                         |
| ------------------------ | ----------------------------- | ------------------------------------------------------- |
| Powershell-core (PS 7.1) | Chocolatey                    | `choco install powershell-core`                         |
| PS-Module Az             | PowerShell (Module Installer) | `Install-Module -Name Az -AllowClobber -Scope AllUsers` |
| K8s CLI                  | Chocolatey                    | `choco install kubernetes-cli`                          |

#### Create Cluster (Powershell)

I extended the script provided by cloudskills to also create the resource group.
With that all you need to do is run the script from the `Powershell` directory.

### Create AKS with Terraform

#### Software (Create AKS with Terraform)

| Name      | Installation Method | Install Command                |
| --------- | ------------------- | ------------------------------ |
| Terraform | Chocolatey          | `choco install terraform`      |
| K8s CLI   | Chocolatey          | `choco install kubernetes-cli` |

#### Create AKS Cluster (Terraform)

To create the same AKS cluster with terraform just run the following commands from the Terraform directory (no tfvars is needed):

```Powershell
terraform init
terraform plan -out=plan ; terraform apply plan
```

### Get Cluster Credentials (AKS)

With our cluster running use the following command to get the k8s-config which is needed for you to run commands against it.

```Powershell
az aks get-credentials --name devaks21 --resource-group AKS
```

### Test Cluster Connection (AKS)

Run at least one of the following commands to test your connection and get some information about your cluster.

```Powershell
# List all nodes in cluster
kubectl get nodes
```

```Powershell
# List all pods in cluster
kubectl get pods -A
```

```Powershell
# List all namespaces in cluster
kubectl get namespace
```

### Destroy AKS Cluster (Terraform)

Always remember to destroy your deployments after you finished testing everything to keep your costs low.
Destroy your terraform deployment with the following command:

```Powershell
terraform destroy
```

## Project 3 - Deploying to AKS

Based on the previous project we will deploy a demo workload to the AKS cluster.

### Software (Deploy to AKS)

| Name    | Installation Method | Install Command                |
| ------- | ------------------- | ------------------------------ |
| K8s CLI | Chocolatey          | `choco install kubernetes-cli` |

### Deploy to AKS

To deploy our nginx pod including the added service run the following command:

```Powershell
kubectl apply -f nginx.yml
```

Check your deployment with the following command:

```Powershell
kubectl get deployments
```

With the following command you can get infrmations about your deployed services.
If you copy the `EXTERNAL-IP` of the `nginx-service` into your browser you should be able to see the default page of nginx.

```Powershell
kubectl get service
```

## Project 4 - Creating an EKS cluster

Similar to project 2 we create an EKS cluster on AWS.
This time with terraform only.

### Software (Create EKS with Terraform)

| Name      | Installation Method | Install Command           |
| --------- | ------------------- | ------------------------- |
| Terraform | Chocolatey          | `choco install terraform` |

### Create EKS

To create the EKS cluster with terraform just run the following commands from the Terraform directory (no tfvars is needed):

```Powershell
terraform init
terraform plan -out=plan
terraform apply plan
```

### Destroy EKS Cluster (Terraform)

Always remember to destroy your deployments after you finished testing everything to keep your costs low.
Destroy your terraform deployment with the following command:

```Powershell
terraform destroy
```

## Project 5 - Deploying to EKS

In this project we will see how deploy the same workload of project 3 to our EKS cluster.
As you will see only the step of how to get the credentials for connecting to the cluster is different.

### Software (Deploy to EKS)

| Name                     | Installation Method | Install Command                 |
| ------------------------ | ------------------- | ------------------------------- |
| Powershell-core (PS 7.1) | Chocolatey          | `choco install powershell-core` |
| AWS-CLI                  | Chocolatey          | `choco install awscli`          |
| K8s CLI                  | Chocolatey          | `choco install kubernetes-cli`  |

### Get Cluster Credentials (EKS)

With our cluster running use the following command to get the k8s-config which is needed for you to run commands against it.

```Powershell
az aks get-credentials --name devaks21 --resource-group AKS
```

### Test Cluster Connection (EKS)

Run at least one of the following commands to test your connection and get some information about your cluster.

```Powershell
# List all nodes in cluster
kubectl get nodes
```

```Powershell
# List all pods in cluster
kubectl get pods -A
```

```Powershell
# List all namespaces in cluster
kubectl get namespace
```

### Deploy to EKS

To deploy our nginx pod including the added service run the following command again from the Week 8 root directory:

```Powershell
kubectl apply -f nginx.yml
```

Check your deployment with the following command:

```Powershell
kubectl get deployments
```

With the following command you can get infrmations about your deployed services.
If you copy the `EXTERNAL-IP` of the `nginx-service` into your browser you should be able to see the default page of nginx.

```Powershell
kubectl get service
```

## Project 6 - Using Azure ACI

In this project we will deploy a single container to Azure Container Instance (ACI) without the need to run a complete kubertnetes cluster.

### Software (ACI)

| Name      | Installation Method | Install Command           |
| --------- | ------------------- | ------------------------- |
| Terraform | Chocolatey          | `choco install terraform` |

### Deploy to ACI

With only the provided terraform module and the following commands, we can deploy a demo-app to ACI.

```Powershell
terraform init
terraform plan -out=plan
terraform apply plan
```

### Check Deployment (ACI)

To see your deployed container "in action" go to the Azure portal and search for `ACI` and the click on `Container Instances`.
Select your container group and click on `Container`.
There you should be able to see the new container running.

### Destroy ACI Deployment

Always remember to destroy your deployments after you finished testing everything to keep your costs low.
Destroy your terraform deployment with the following command:

```Powershell
terraform destroy
```

## Project 7 - Using AWS Fargate

For this project I also used terraform to provide the whole infrastructure including the deployed container.  
Kudos to [Oxalide](https://github.com/Oxalide) which provided the [terraform-fargate-example](https://github.com/Oxalide/terraform-fargate-example), which I based the whole deployment on. the only changes that I made were to remove Vault as store for AWS credentials and also updated the code to modern terraform variable calls without "${var}" syntax.

### Software (AWS Fargate)

| Name      | Installation Method | Install Command           |
| --------- | ------------------- | ------------------------- |
| Terraform | Chocolatey          | `choco install terraform` |

### Set variables (AWS Fargate)

To use the provided terraform module you need to save the following code as `terraform.tfvars` and enter all infos to be able to deploy to your account:

```hcl
aws_access_key = "<YOUR-AWS-ACCESS-KEY>"
aws_secret_key = "<YOUR-AWS-SECRET-KEY>"
aws_account_id = "<YOUR-AWS-ACCOUNT-ID>"
aws_region     = "eu-west-1"
app_image      = "nginx:latest"
app_port       = 80
app_count      = 1
```

### Deploy Fargate and Container

With only the provided terraform module and the following commands, we can deploy a demo-app to Fargate.

```Powershell
terraform init
terraform plan -out=plan
terraform apply plan
```

### Destroy Fargate Deployment

Always remember to destroy your deployments after you finished testing everything to keep your costs low.
Destroy your terraform deployment with the following command:

```Powershell
terraform destroy
```

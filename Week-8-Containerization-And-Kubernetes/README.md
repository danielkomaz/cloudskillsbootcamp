# Week 8 - Containerization and Kubernetes

_Note:_ If you are looking for a good and handy GUI/IDE for administrating/developing on k8s clusters you should have a look at [Lens](https://k8slens.dev/).

## Project 1 - Creating a Minikube environment

### Software (Minikube)

| Name     | Installation Method | Install Command          |
| -------- | ------------------- | ------------------------ |
| Minikube | Chocolatey          | `choco install minikube` |

### Create Deployment

After instaling minikube you should be able to to run one of the following command from the Project-1 directory to start the deployment:

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

### Project 2 - Creating an AKS Cluster

There are several ways to create an AKS cluster.
In this repo I show you two of them.

#### Create AKS with Powershell

##### Software (Create AKS with Powershell)

| Name                     | Installation Method           | Install Command                                         |
| ------------------------ | ----------------------------- | ------------------------------------------------------- |
| Powershell-core (PS 7.1) | Chocolatey                    | `choco install powershell-core`                         |
| PS-Module Az             | PowerShell (Module Installer) | `Install-Module -Name Az -AllowClobber -Scope AllUsers` |
| K8s CLI                  | Chocolatey                    | `choco install kubernetes-cli`                          |

##### Create Cluster (Powershell)

I extended the script provided by cloudskills to also create the resource group.
With that all you need to do is run the script from the `Powershell` directory.

#### Create AKS with Terraform

##### Software (Create AKS with Terraform)

| Name      | Installation Method | Install Command                |
| --------- | ------------------- | ------------------------------ |
| Terraform | Chocolatey          | `choco install terraform`      |
| K8s CLI   | Chocolatey          | `choco install kubernetes-cli` |

##### Create Cluster (Terraform)

To create the same AKS cluster with terraform just run the following commands from the Terraform directory (no tfvars is needed):

```Powershell
terraform init
terraform plan -out=plan ; terraform apply plan
```

#### Get Cluster Credentials

With our cluster running use the following command to get the k8s-config which is needed for you to run commands against it.

```Powershell
az aks get-credentials --name devaks21 --resource-group AKS
```

#### Test Cluster Connection

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

### Project 3 - Deploying to AKS

#### Software (Deploy to AKS)

| Name      | Installation Method | Install Command                |
| --------- | ------------------- | ------------------------------ |
| Terraform | Chocolatey          | `choco install terraform`      |
| K8s CLI   | Chocolatey          | `choco install kubernetes-cli` |

####

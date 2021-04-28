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

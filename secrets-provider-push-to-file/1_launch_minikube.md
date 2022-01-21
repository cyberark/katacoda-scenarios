This scenario uses Katacoda's `minikube` image. Before we begin, lets make sure
that the minikube cluster is running:

```
minikube start
```{{execute}}

Before continuing, wait for the terminal to output:

```
Done! kubectl is now configured to use "minikube"
```

Install the latest versions of `kubectl` and `helm`:

```
snap install --classic kubectl
snap install --classic helm
export PATH="/snap/bin:$PATH"
```{{execute}}

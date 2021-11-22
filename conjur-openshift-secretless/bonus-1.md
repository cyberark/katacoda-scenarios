
## Do you know?

Apart from secretless broker, there're a few more ways to secure secrets in apps on OpenShift by Conjur:

- *Kubernetes Authenticator* as init container, that inject secrets as env variable when app starts
- *Kubernetes Authenticator* as sidecar, that keeps updating access token when apps is alive
- *Secrets Provider for Kubernetes* as init container, that update secrets as OpenShift secrets when app starts
- *Secrets Provider for Kubernetes* as a Job, that update secrets as OpenShift secrets when Job starts

We are going to cover tham in next few steps.
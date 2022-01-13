# Overview

This quick-start will serve as a guide for deploying an application that uses
CyberArk's Secrets Provider in Push-to-File mode, where secrets are provided to
the consuming application through a shared volume in a Kubernetes cluster.

For more information, see the
[Secrets Provider GitHub repository](https://github.com/cyberark/secrets-provider-for-k8s).

## We will...

1. Deploy Conjur Open Source to a Kubernetes Cluster
2. Configure the Conjur Kubernetes Authenticator
3. Install the Conjur Configuration Helm charts
4. Configure and deploy the demo
   [Pet Store application](https://github.com/conjurdemos/pet-store-demo) with
   Secrets Provider

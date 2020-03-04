<p align="center">
  <img src="assets/cyberark_logo.png">
</p>

# Introduction

In this scenario, you will get an overview of the Secretless Broker and learn how to deploy it, along with an application that has *no knowledge of passwords* and a database backend.

## What is Secretless Broker?
With the Secretless Broker feature of Conjur, applications can securely connect to databases, services and other protected resources – without fetching or managing secrets.

Secretless Broker is an independent and extensible open source community project maintained by CyberArk.  Today Secretless Broker works within Kubernetes and OpenShift container platforms with Conjur, Application Access Manager’s Dynamic Access Provider, and Kubernetes Secrets vaults.

<p align="center">
  <img width="300" height="300" src="https://www.conjur.org/wp-content/uploads/2019/07/secretless-arch-infographic.svg">
</p>

## How Does Secretless Broker Work?
When an application needs to securely access a resource, such as a database, instead of providing access credentials, the app simply makes a local connection request to Secretless Broker, which then automatically authenticates the app, fetches the required credentials from a Vault and establishes a connection to the database.

* From the developer’s perspective instead of needing to include code in their application to fetch the credentials from a Vault and then use the credentials to access the resource, the developer simply configures the application to connect to the required resource via the Secretless Broker, without needing to change the application code.
* From the security perspective, credentials can no longer be inadvertently logged or exposed by the application because, with Secretless Broker, the application code does not get access to the credential, so it cannot leak secrets.

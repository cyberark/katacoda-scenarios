# Welcome to: Using the Java client library to access the Conjur API!

Welcome to Conjur's tutorial of how to use our Java client library to access our Conjur API.

In this tutorial, you will learn how to run a local Java application that connects to the Conjur API given an access token provided by a Kubernetes authenticator sidecar on a local Kubernetes cluster using Minikube, login to the Conjur CLI, authenticate and set policies, and fetch a secret.

## Overview
Applications and application developers should be incapable of leaking secrets.

In order to achieve this goal, you will play three roles in this tutorial:
1. An **Infrastructure Engineer**, who will deploy an instance of Conjur
2. A **Security Admin** who handles secrets, and has sole access to their secrets
3. An **Application Developer** who wants to deploy their Java application to Kubernetes, and make sure it has the credentials to connect to the resources it needs

Specifically, we will:

**As the Infrastructure Engineer:**
1. Create an instance of Conjur OSS and a PostgreSQL database

**As the Security Admin**
1. Create a new application identity in Conjur
2. Stores the secrets the application will need, and ensure the app will be able to access them
3. Provides the developer with Conjur configuration instructions for their application

**As the Application Developer:**
1. Create an application to use the token and Java Client to retrieve the given secrets
2. Update their application manifest

# Up Next...
Start as an Infrastructure Engineer to install an instance of Conjur for our Security Admin and Application Developer to use for development.

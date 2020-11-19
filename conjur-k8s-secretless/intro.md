## Before we begin...
This is a detailed, step-by-step tutorial for securing secrets of kubernetes-based applications

We will:
1. Deploy a typical kubernetes application with database
2. Discover the risk
3. Deploy Conjur on Kubernetes
4. Store its credentials in Kubernetes secrets
5. Setup Secretless Broker to proxy connections to it
6. Deploy an application that connects to the database without knowing its password


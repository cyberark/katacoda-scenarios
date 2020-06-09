# Installing Conjur OSS and the Conjur CLI

**You are now the Infrastructure Engineer.**

The Infrastructure Engineer is responsible for creating our instance of Conjur and setting up our PostgreSQL database.

In this section, we will act as the Infrastructure Engineer by setting our namespace, pulling the latest version of Docker, and starting our Conjur client.

1. Create and set the environment namespace

   `pushd kubernetes-install`{{execute}}

   `kubectl create namespace java-demo`{{execute}}

   `kubectl config set-context $(kubectl config current-context) --namespace=java-demo`{{execute}}

   <details>
      <summary>Click here to see expected output...</summary>
      ```
namespace/demo-java-client created
Context "minikube" modified.
      ```
    </details>

2. Pull the latest version of Conjur from Docker Hub

   `docker pull cyberark/conjur:latest`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
latest: Pulling from cyberark/conjur
ab5f5ccbe527: Pull complete
Digest: sha256:2884742777452eb85308131f8b2732ad53f944cc1ac43cbe8bc902790f816e22
Status: Downloaded newer image for cyberark/conjur:latest
docker.io/cyberark/conjur:latest
     ```
   </details>

3. Generate a data key

   We need to generate a data key and load it in as a system variable. This data key will allow us to start up our Conjur client.

   `DATA_KEY=$(docker-compose run --no-deps --rm conjur data-key generate)`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
    Creating network "kubernetesinstall_default" with the default driver
     ```
   </details>

   We then write this data key to our `custom-values.yaml` file to be included when we deploy our helm chart to install Conjur and deploy our PostgreSQL database.

   `cat custom-values.yaml | awk "{gsub(/{{ DATA_KEY }}/,\"$DATA_KEY\")}1" > custom-values.yaml.tmp`{{execute}}

   `cat custom-values.yaml.tmp > custom-values.yaml`{{execute}}

   `rm -rf custom-values.yaml.tmp`{{execute}}

4. Install Conjur OSS and a PostgreSQL database via helm

   Our `custom-values.yaml` file allows us to customize important chart values. We use helm to deploy the latest version of `cyberark/conjur`. We are specifying the data key we generated in the previous step, the account name to be used by the Kubernetes authenticator, and turning off persistent volumes for our PostgreSQL database.

   `helm install conjur-oss --namespace java-demo -f custom-values.yaml  https://github.com/cyberark/conjur-oss-helm-chart/releases/download/v1.3.8/conjur-oss-1.3.8.tgz`{{execute}}

5. Wait for the Conjur OSS and PostgreSQL pod to run

   `kubectl get pods`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
NAME                                   READY   STATUS    RESTARTS   AGE
conjur-oss-<pod-identifier>            2/2     Running   0          101s
conjur-oss-postgres-<pod-identifier>   1/1     Running   0          101s
     ```
   </details>

# Up Next...
Continue as a Security Admin to create an account to login to Conjur

# Installing and setting up Conjur-OSS

In this section, we will create our kubernetes namespace, pull the Conjur docker image from Docker Hub, create our data key, and start our Conjur-CLI, Conjur-OSS and Conjur-OSS-Postgres containers.

Some environment variables have been preset for the use of this tutorials:
* PROJECT_NAME
* ACCOUNT_NAME
* AUTHENTICATOR
* DEPLOYMENT_NAME

<!-- 1. Setting the necessary variables

   So we can refer to them later, export the project name, account name, authenticator and deployment name as environment variables:

   `export PROJECT_NAME=demo-java-client
export ACCOUNT_NAME=demo-account
export AUTHENTICATOR=demo-authenticator
export DEPLOYMENT_NAME=conjur-java-api-example
   `{{execute}} -->

1. Create and set the environment namespace

    `cd ..
cd kubernetes-install
kubectl create namespace $PROJECT_NAME
kubectl config set-context $(kubectl config current-context) --namespace=$PROJECT_NAME
    `{{execute}}

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

    `DATA_KEY=$( docker-compose run --no-deps --rm conjur data-key generate )`{{execute}}

    <details>
      <summary>Click here to see expected output...</summary>
      ```
      Creating network "kubernetesinstall_default" with the default driver
      ```
    </details>

4. Generate template for Conjur-OSS using environmental variables

    `cat templates/custom-values.yaml | sed s/'{{ AUTHENTICATOR }}'/$AUTHENTICATOR/g | sed s/'{{ ACCOUNT_NAME }}'/$ACCOUNT_NAME/g > custom-values.yaml.tmp
cat custom-values.yaml.tmp | awk "{gsub(/{{ DATA_KEY }}/,\"$DATA_KEY\")}1" > custom-values.yaml
rm -rf custom-values.yaml.tmp
    `{{execute}}

5. Install Conjur-OSS via helm

   `helm install conjur-oss --namespace $PROJECT_NAME -f custom-values.yaml  https://github.com/cyberark/conjur-oss-helm-chart/releases/download/v1.3.8/conjur-oss-1.3.8.tgz
   `{{execute}}

6. Check pod status

   `kubectl get pods`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
NAME                                   READY   STATUS    RESTARTS   AGE
conjur-oss-6f8cdb75b6-fh64w            2/2     Running   0          101s
conjur-oss-postgres-86bcdbff6c-gzgpq   1/1     Running   0          101s
     ```
   </details>

7. Create an account

   `CONJUR_OSS_POD_LINE=$( kubectl get pods | grep conjur-oss | (head -n1 && tail -n1) )
CONJUR_OSS_POD=$( echo "$CONJUR_OSS_POD_LINE" | awk '{print $1}' )
CONJUR_OUTPUT_INIT=$( kubectl exec "$CONJUR_OSS_POD" --container=conjur-oss conjurctl account create $ACCOUNT_NAME )
API_KEY=$( echo "$CONJUR_OUTPUT_INIT" |  grep "API key" | awk '{print $5}' )
   `{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
     Created new account 'demo-account'
     ```
   </details>

8. Create Conjur-CLI pod

    `kubectl create -f conjur-cli.yaml`{{execute}}

    <details>
      <summary>Click here to see expected output...</summary>
      ```
    deployment.apps/conjur-cli created
      ```
    </details>

9. Check pod status

   `kubectl get pods`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
NAME                                   READY   STATUS    RESTARTS   AGE
conjur-cli-ff5d759fb-78php             1/1     Running   0          37s
conjur-oss-6f8cdb75b6-4zqbt            2/2     Running   0          2m1s
conjur-oss-postgres-86bcdbff6c-m4v28   1/1     Running   0          2m1s
     ```
   </details>

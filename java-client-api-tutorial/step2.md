# Installing and setting up Conjur-OSS

In this section, we will set our environmental variables to be used in development, create our kubernetes namespace, pull the Conjur docker image from Docker Hub, create our data key, and start our Conjur-CLI, Conjur-OSS and Conjur-OSS-Postgres containers.

1. Setting the necessary variables

   So we can refer to them later, export the project name, account name, authenticator and deployment name as environment variables:

   `export PROJECT_NAME=demo-java-client
export ACCOUNT_NAME=demo-account
export AUTHENTICATOR=demo-authenticator
export DEPLOYMENT_NAME=conjur-java-api-example
   `{{execute}}

2. **If you would like to continue with the tutorial, please skip this step.**

    We have provided a script in `kubernetes-install/java-client-installer` which will install and configure the necessary pods to run the Conjur Java Client API. If you would like to use that script, you can do so with the following command:

    `cd
cd kubernetes-install
./java-client-installer.sh --project-name $PROJECT_NAME --account-name $ACCOUNT_NAME --authenticator $AUTHENTICATOR`{{execute}}

3. Create and set the environment namespace

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

4. Pull the latest version of Conjur from Docker Hub

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

5. Generate a data key

    `DATA_KEY=$( docker-compose run --no-deps --rm conjur data-key generate )`{{execute}}

    <details>
      <summary>Click here to see expected output...</summary>
      ```
      Creating network "kubernetesinstall_default" with the default driver
      ```
    </details>

6. Generate template for Conjur-OSS using environmental variables

    `cat templates/custom-values.yaml | sed s/'{{ AUTHENTICATOR }}'/$AUTHENTICATOR/g | sed s/'{{ ACCOUNT_NAME }}'/$ACCOUNT_NAME/g > custom-values.yaml.tmp
cat custom-values.yaml.tmp | awk "{gsub(/{{ DATA_KEY }}/,\"$DATA_KEY\")}1" > custom-values.yaml
rm -rf custom-values.yaml.tmp
    `{{execute}}

7. Install Conjur-OSS via helm

   `helm install conjur-oss --namespace $PROJECT_NAME -f custom-values.yaml  https://github.com/cyberark/conjur-oss-helm-chart/releases/download/v1.3.8/conjur-oss-1.3.8.tgz
   `{{execute}}

8. Check pod status

   `kubectl get pods`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
NAME                                   READY   STATUS    RESTARTS   AGE
conjur-oss-6f8cdb75b6-fh64w            2/2     Running   0          101s
conjur-oss-postgres-86bcdbff6c-gzgpq   1/1     Running   0          101s
     ```
   </details>

9. Create an account

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

10. Create Conjur-CLI pod

    `
kubectl create -f conjur-cli.yaml
    `{{execute}}

    <details>
      <summary>Click here to see expected output...</summary>
      ```
    deployment.apps/conjur-cli created
      ```
    </details>

11. Check pod status

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

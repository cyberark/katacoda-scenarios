# Running the Java Client Docker Image

In this section, we will start our Java client docker image, and then use it to fetch our secret variable that we set in the previous section.

1. Tag the Java client docker image

   `docker tag conjur-java-client:latest $PROJECT_NAME/conjur-java-client:latest`{{execute}}

2. Configure the Conjur Java client for Kubernetes

    `cat templates/conjur-java-api-example.yaml | sed s/'{{ AUTHENTICATOR }}'/$AUTHENTICATOR/g | sed s/'{{ ACCOUNT_NAME }}'/$ACCOUNT_NAME/g | sed s/'{{ DEPLOYMENT_NAME }}'/$DEPLOYMENT_NAME/g | sed s/'{{ PROJECT_NAME }}'/$PROJECT_NAME/g > conjur-java-api-example.yaml
    `{{execute}}

3. Run the Conjur Java client in Kubernetes

  `kubectl create -f conjur-java-api-example.yaml --validate=false`{{execute}}

  <details>
    <summary>Click here to see an expected output...</summary>
    ```
    deployment.apps/conjur-java-api-example created
    ```
  </details>

4. Assign the pod name to a variable so we can fetch our secret

    `CONJUR_JAVA_API_POD_LINE=$( kubectl get pods | grep conjur-java-api-example | (head -n1 && tail -n1) )
CONJUR_JAVA_API_POD=$( echo "$CONJUR_JAVA_API_POD_LINE" | awk '{print $1}' )
    `{{execute}}

5. Wait for the Conjur Java client pod to be up

  `kubectl get pods`{{execute}}

6. Use the Conjur Java client to fetch our secret

  `kubectl logs $CONJUR_JAVA_API_POD -c my-conjur-java-client`{{execute}}

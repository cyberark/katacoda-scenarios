# Running the Java Client Docker Image

**You are now the Application Developer.**

Now that our Security Admin has added our secrets, we can run our application with our authenticator sidecar helping us access our secret to be used in our application.

For the purpose of this tutorial, our application is a simple Java app that prints out the value of our secret value. However, real-world uses include connecting to an API or database.

1. Build out our local Java application.

  We have built a Dockerfile to create the Java Client jarfile for you, which you can execute in `conjur-java-client/build.sh`.

  `popd`{{execute}}

  `pushd conjur-java-client`{{execute}}

  `./build.sh`{{execute}}

  <details>
    <summary>The build script should end in the following lines...</summary>
    ```
  Successfully built cea0c911b9df
  Successfully tagged conjur-java-client:latest
  conjur-java-client                              latest              cea0c911b9df        Less than a second ago   56
    ```
  </details>

2. Run the Conjur Java client in Kubernetes

   `kubectl create -f conjur-java-api-example.yaml --validate=false`{{execute}}

   <details>
     <summary>Click here to see an expected output...</summary>
     ```
    deployment.apps/conjur-java-api-example created
     ```
   </details>

3. Assign the pod name to a variable so we can fetch our secret

  `CONJUR_JAVA_API_POD=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep conjur-java-api-example)`{{execute}}

4. Wait for the Conjur Java client pod to be up

  `kubectl get pods`{{execute}}

5. Use the Conjur Java client to fetch our secret

  `kubectl logs $CONJUR_JAVA_API_POD -c my-conjur-java-client`{{execute}}

## Up next...
A summary of what you accomplished in this tutorial!

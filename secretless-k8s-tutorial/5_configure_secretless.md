<p align="center">
  <img src="assets/security_admin.jpg">
</p>
**You are continuing in your role as a Security Admin.**

## Create Secretless Broker Configuration ConfigMap
With our database ready and our credentials safely stored, we can now configure the Secretless Broker. We’ll tell it where to listen for connections and how to proxy them.

After that, the developer’s application can access the database without ever knowing the application-credentials.

A Secretless Broker configuration file defines the services that Secretless with authenticate to on behalf of your application.
The Secretless Broker configuration file can be viewed here: [secretless.yml](secretless.yml)

Here’s what this configuration does:

* Defines a service called `pets-pg` that listens for PostgreSQL connections on `localhost:5432`
* Says that the database `host`, `port`, `username` and `password` are stored in Kubernetes Secrets
* Lists the ids of those credentials within Kubernetes Secrets

**Note:** This configuration is shared by all Secretless Broker sidecar containers. There is one Secretless sidecar in every application Pod replica.
**Note:** Since we don't specify an `sslmode` in the Secretless Broker config, it will use the default `require` value.

Next we create a Kubernetes ConfigMap from this secretless.yml:

`kubectl --namespace demo-app-ns \
   create configmap \
   demo-app-secretless-config \
   --from-file=secretless.yml`{{execute}}

<details>
  <summary>Click here to see expected output...</summary>

  ```
configmap/demo-app-secretless-config created
  ```
</details>

To view the contents of the ConfigMap that was created:

`kubectl --namespace demo-app-ns describe cm demo-app-secretless-config`{{execute}}

<details>
  <summary>Click here to see expected output...</summary>

  ```
Name:         demo-app-secretless-config
Namespace:    demo-app-ns
Labels:       <none>
Annotations:  <none>

Data
====
secretless.yml:
----
version: "2"
services:
  pets-pg:
    connector: pg
    listenOn: tcp://localhost:5432
    credentials:
      host:
        from: kubernetes
        get: demo-app-backend-credentials#host
      port:
        from: kubernetes
        get: demo-app-backend-credentials#port
      username:
        from: kubernetes
        get: demo-app-backend-credentials#username
      password:
        from: kubernetes
        get: demo-app-backend-credentials#password

Events:  <none>
  ```
</details>


## Up next...
As an Application Developer, you no longer need to worry about all the passwords and database connections! You will deploy an application and leave it up to the Secretless Broker to make the desired connection to the database.

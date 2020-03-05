<p align="center">
  <img src="assets/application_developer.jpg">
</p>

**You are now the Application Developer**

You can no longer access the secrets we stored previously in environment variables. To clear these environment variables, you can run the following:

`./clear_admin_env.sh`{{execute}}

You know only one thing – the name of the database, namely **demo_app_db**.

## Sample Application Overview

The application we’ll be deploying is a [pet store demo application](https://github.com/conjurdemos/pet-store-demo) with a simple API:

* `GET /pets` lists all the pets
* `POST /pet` adds a pet

Its PostgreSQL backend is configured using a `DB_URL` environment variable:

```
postgresql://localhost:5432/demo_app_db?sslmode=disable
```

Again, the application has no knowledge of the database credentials it’s using.

## Create Application Deployment and Service

We’re ready to deploy our demo application and service using the YAML manifest that can be viewed here: [demo-app-deployment.yml](demo-app-deployment.yml).

A detailed explanation of the manifest below is featured in the next step, `Step 7 - Secretless Deployment Manifest Explained` and isn’t needed to complete the tutorial.

To deploy the application, run:

`kubectl --namespace demo-app-ns apply -f demo-app-deployment.yml`{{execute}}

<details>
  <summary>Click here to see expected output...</summary>

  ```
deployment.apps/demo-application created
service/demo-application created
  ```
</details>

Before moving on, verify that the pods are healthy. It may take a minute or so for the pods to get to the `Running` state:

`kubectl --namespace demo-app-ns get pods`{{execute}}

<details>
  <summary>Click here to see expected output...</summary>

  ```
NAME                                READY   STATUS    RESTARTS   AGE
demo-application-5df4dc5b87-k6r4m   2/2     Running   1          26s
demo-application-5df4dc5b87-w7zj6   2/2     Running   1          26s
demo-application-5df4dc5b87-zffpd   2/2     Running   1          26s
  ```
</details>

The demo application service is exposed on port 30002 on all Kubernetes nodes.
To see this:

`kubectl --namespace demo-app-ns get svc`{{execute}}

<details>
  <summary>Click here to see expected output...</summary>

  ```
NAME               TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
demo-application   NodePort   10.96.100.50   <none>        8080:30002/TCP   81s
  ```
</details>

Congratulations!
The application is now available on port 30002 on any Kubernetes node.

## Test the Application

To access the application, we'll use:
* The IP address of the worker node (IP address of either node would do)
* The NodePort on which this service is exposed (30001)

The IP address of the worker node can be displayed with this command:

`kubectl get nodes -o wide | grep -v "master"`{{execute}}

Let's create an APPLICATION_URL environment variable based on the worker node IP address and port 30001:

`export APPLICATION_URL=[[HOST2_IP]]:30002`{{execute}}

Now let’s create a pet (POST /pet):

`curl -i -d @- \
 -H "Content-Type: application/json" \
 ${APPLICATION_URL}/pet \
 << EOF
{
   "name": "Secretlessly Fluffy"
}
EOF`{{execute}}

We should get a 201 response status.  

<details>
  <summary>Click here to see expected output...</summary>

  ```
HTTP/1.1 201
Location: http://[[HOST2_IP]].100:30002/pet/1
Content-Length: 0
Date: Mon, 18 Feb 2020 11:56:27 GMT
  ```
</details>

Now let’s retrieve all the pets (GET /pets):

`curl -i ${APPLICATION_URL}/pets`{{execute}}

We should get a 200 response with a JSON array of the pets.

<details>
  <summary>Click here to see expected output...</summary>

  ```
HTTP/1.1 200
Content-Type: application/json;charset=UTF-8
Transfer-Encoding: chunked
Date: Mon, 18 Feb 2020 11:58:36 GMT

[{"id":1,"name":"Secretlessly Fluffy"}]
  ```
</details>

That’s it!

The application is connecting to a password-protected Postgres database **without any knowledge of the credentials**.

<p align="center">
  <img src="https://secretless.io/img/its_magic.jpg">
</p>

For more info on configuring Secretless for your own use case, see the [Secretless Documentation](https://docs.secretless.io/Latest/en/Content/Overview/scl_how_it_works.htm)

# Up next...

Get a closer look at Secretless

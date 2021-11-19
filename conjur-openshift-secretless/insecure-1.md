
Let's deploy an app.   

## Project

To create a project 

`oc new-project testapp`{{execute}}


## Database

Let's setup a database for the application

```
oc new-app \
 -e POSTGRESQL_USER=test_app \
 -e POSTGRESQL_PASSWORD=5b3e5f75cb3cdc725fe40318 \
 -e POSTGRESQL_DATABASE=test_app \
 --image-stream="openshift/postgresql:9.6-el8" \
 --name=testapp-db
oc expose service/testapp-db
```{{execute}}

## App

We will make use of the pet store demo app from CyberArk (https://github.com/conjurdemos/pet-store-demo) as an example.

To deploy, execute:
```
oc apply -f insecure/app.yml
oc expose service/testapp-insecure
```{{execute}}

Now the application has been installed.

```
oc get pods -n testapp -w
```{{execute}}

Let's wait for it to get started.
```
master $ oc get pods -n testapp -w
NAME                                READY   STATUS    RESTARTS   AGE
testapp-db-6b6958ccf6-tmzlq         0/1     Pending   0          10s
testapp-insecure-846bdf65db-dbwsj   0/1     Pending   0          10s
testapp-insecure-846bdf65db-dbwsj   0/1     Pending   0          17s
testapp-db-6b6958ccf6-tmzlq         0/1     Pending   0          17s
testapp-insecure-846bdf65db-dbwsj   0/1     Pending   0          28s
testapp-db-6b6958ccf6-tmzlq         0/1     Pending   0          28s
testapp-insecure-846bdf65db-dbwsj   0/1     ContainerCreating   0          28s
testapp-db-6b6958ccf6-tmzlq         0/1     ContainerCreating   0          28s
testapp-db-6b6958ccf6-tmzlq         1/1     Running             0          62s
testapp-insecure-846bdf65db-dbwsj   1/1     Running             0          71s
```

Wait for both `testapp-db` & `testapp-app`to have `Running` status.
Press `Ctrl-C` or `clear`{{execute interrupt}} to stop

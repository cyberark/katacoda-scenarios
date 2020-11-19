
Let's deploy an app.   

## Database

Let's setup a database for the application

`kubectl apply -f db/db.yml`{{execute HOST1}}


## App

We will make use of the pet store demo app from CyberArk (https://github.com/conjurdemos/pet-store-demo) as an example.

To deploy, execute:
`kubectl apply -f insecure/app.yml`{{execute HOST1}}

Now the application has been installed.

Let's wait it to be started

```
kubectl get pods -n testapp -w
```{{execute HOST1}}

```
master $ kubectl get pods -n testapp -w
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
Press `Ctrl-C` to stop

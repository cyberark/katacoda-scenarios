Here we’ll walk through the application [deployment manifest](assets/demo-app-deployment.yml), to better understand how Secretless works.

We’ll focus on the Pod’s template, which is where the magic happens:

```
  # top part elided...
  template:
    metadata:
      labels:
        app: demo-application
    spec:
      serviceAccountName: demo-app-svc-account
      automountServiceAccountToken: true
      containers:
        - name: demo-application
          image: cyberark/demo-app:latest
          env:
            - name: DB_URL
              value: postgresql://localhost:5432/demo_app_db?sslmode=disable
        - name: secretless-broker
          image: cyberark/secretless-broker:latest
          imagePullPolicy: Always
          args: ["-f", "/etc/secretless/secretless.yml"]
          volumeMounts:
            - name: config
              mountPath: /etc/secretless
              readOnly: true
      volumes:
        - name: config
          configMap:
            name: demo-app-secretless-config
```

## Networking
Since it resides in the same pod, the application can access the Secretless sidecar container over localhost.

As specified in the ConfigMap we created, Secretless listens on port 5432, and hence this:

```
          env:
            - name: DB_URL
              value: postgresql://localhost:5432/demo_app_db?sslmode=disable
```

is all our application needs to locate Secretless.

## SSL

Notice the `?sslmode=disable` at the end of our DB_URL?

This means that the application connects to Secretless without SSL, which is safe because it is intra-Pod communication over localhost.

However, the connection between Secretless and Postgres is secure, and does use SSL.

The situation looks like this:

                 No SSL                       SSL
Application   <---------->   Secretless   <---------->   Postgres
For more information on PostgreSQL SSL modes see:

* [PostgreSQL SSL documentation](https://www.postgresql.org/docs/9.6/libpq-ssl.html)
* [PostgreSQL Secretless Service Connector documentation](https://docs.secretless.io/Latest/en/Content/References/connectors/postgres.htm)

## Credential Access

Notice we add the quick-start-application ServiceAccount to the pod:

```
    spec:
      serviceAccountName: demo-app-svc-account
```

That’s the ServiceAccount we created earlier, the one with access to the credentials in Kubernetes Secrets. This is what gives Secretless access to those credentials.

## Configuration Access

Finally, notice the sections defining the volumes and the volume mount in the Secretless container:

```
          # ... elided
          volumeMounts:
            - name: config
              mountPath: /etc/secretless
              readOnly: true
      volumes:
        - name: config
          configMap:
            name: demo-app-secretless-config
```

Here we create a volume base on the ConfigMap we created earlier, which stores our secretless.yml configuration file.

Thus Secretless gets its configuration file via a volume mount.

# Up next...

A summary of what you accomplished in this tutorial!

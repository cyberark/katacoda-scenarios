<p align="center">
  <img src="assets/security_admin.jpg">
</p>
**You are now the Security Admin**

The Security Admin sets up PostgreSQL, configures Secretless, and has sole access to the credentials.

## Deploy a PostgreSQL Statefulset

PostgreSQL is stateful, so we’ll use a [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) to manage it.

To deploy a PostgreSQL StatefulSet:

1. Create a dedicated namespace for the storage backend:

   `kubectl create namespace postgres-backend-ns`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>

     ```
   namespace/postgres-backend-ns created
     ```
   </details>

2. Create a self-signed certificate (see [PostgreSQL documentation for more info](https://www.postgresql.org/docs/9.6/ssl-tcp.html)):

   `openssl req -new -x509 -days 365 \
      -nodes -text -out server.crt \
      -keyout server.key -subj "/CN=pg"
   chmod og-rwx server.key`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>

     ```
   master $ openssl req -new -x509 -days 365 \
        -nodes -text -out server.crt \
        -keyout server.key -subj "/CN=pg"
   Generating a 2048 bit RSA private key
   ...................................................................................................................+++
   ....................+++
   writing new private key to 'server.key'
   -----
   master $ chmod og-rwx server.key
   master $
      ```
   </details>

3. Store the certificate files as a Kubernetes secret in the postgres-backend-ns namespace:

   `kubectl --namespace postgres-backend-ns \
    create secret generic postgres-backend-certs \
    --from-file=server.crt \
    --from-file=server.key`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>

     ```
   secret/postgres-backend-certs created
     ```
    </details>

   **NOTE:** While Kubernetes Secrets are more secure than hard-coded ones, in a real deployment you should secure secrets in a fully-featured vault, like Conjur.

4. Deploy a PostgreSQL StatefulSet and Service:

   `kubectl --namespace postgres-backend-ns apply -f postgres.yml`{{execute}}

    <details>
      <summary>Click here to see expected output...</summary>

      ```
   statefulset.apps/pg created
   service/postgres-backend created
      ```
    </details>

   View the StatefulSet manifest here: [postgres.yml](./postgres.yml)

    <details>
      <summary>**Some Details:** Click here to see notes for the StatefulSet manifest...</summary>

      <ul>
        <li>The certificate files for your database server are mounted in a volume with *defaultMode: 384* giving it permissions *0600* (Why? Because *600 in base 8* = *384 in base 10*).</li>
        <li>The pod is deployed with *999* as the group associated with any mounted volumes, as indicated by *fsGroup: 999*. *999* is a the static postgres gid, defined in the postgres Docker image</li>
      </ul>
    </details>

   This StatefulSet uses the DockerHub `postgres:9.6` container. On startup, the container creates a superuser from the environment variables:
   * POSTGRES_USER
   * POSTGRES_PASSWORD

   which we set to the values security_admin_user and security_admin_password, respectively.

   Going forward, we’ll call these values the **admin-credentials**, to distinguish them from the **application-credentials** our application will use. In the scripts below, we’ll refer to the **admin-credentials** by the environment variables:
   * SECURITY_ADMIN_USER
   * SECURITY_ADMIN_PASSWORD.

5. Confirm that the PostgreSQL StatefulSet Pod has Started and is Healthy:
   (It may take a minute or so for the pod to get to 'Running' state.)

   `kubectl --namespace postgres-backend-ns get pods`{{execute}}

    <details>
      <summary>Click here to see expected output (it may take a minute or so to get to 'Running' state)...</summary>

      ```
   NAME      READY     STATUS    RESTARTS   AGE
   pg-0      1/1       Running   0          6s
      ```
    </details>

6. Confirm the Successful Creation of the PostgreSQL Service:
   `kubectl --namespace postgres-backend-ns get svc postgres-backend`{{execute}}

    <details>
      <summary>Click here to see expected output (Cluster IP address may be different)...</summary>

      ```
   NAME               TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
   postgres-backend   NodePort   10.106.232.98   <none>        5432:30001/TCP   2m
      ```
    </details>

   **NOTE:** This service is exposed via NodePort 30001 on every node in the cluster. This will be used in the next step.

7. Confirm that You Can Log into the Database and List Users:

   The database has no data yet, but we can verify it works by logging in as the security admin and listing the users.
   To access the postgres-backend service, we'll use:
   * The IP address of the worker node (either node would do)
   * The NodePort on which this service is exposed (30001)

   The IP address of the worker node can be displayed with this command:

   `kubectl get nodes -o wide | grep -v "master"`{{execute}}

   Setting up environment variables for accessing the database:

   `export SECURITY_ADMIN_USER=security_admin_user
   export SECURITY_ADMIN_PASSWORD=security_admin_password
   export REMOTE_DB_HOST=[[HOST2_IP]]
   export REMOTE_DB_PORT=30001`{{execute}}

   And then list the users using a `postgres:9.6` image as a client:

   `docker run --rm -it \
    -e PGPASSWORD=${SECURITY_ADMIN_PASSWORD} \
    postgres:9.6  psql \
    -U ${SECURITY_ADMIN_USER} \
    "postgres://${REMOTE_DB_HOST}:${REMOTE_DB_PORT}/postgres" \
    -c "\du"`{{execute}}

    <details>
      <summary>Click here to see expected output...</summary>

      ```
                                               List of roles
         Role name      |                         Attributes                         | Member of
   ---------------------+------------------------------------------------------------+-----------
    security_admin_user | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
      ```
    </details>

# Up next...
Continue as an Security Admin and set up Application namespace, credentials, and service account

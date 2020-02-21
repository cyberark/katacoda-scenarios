<p align="center">
  <img src="assets/security_admin.jpg">
</p>
**You are continuing in your role as a Security Admin.**

## Create Application Database

In this section, we'll create the application database and user, and securely store the user's credentials:

* Create the application database
* Create the pets table in that database
* Create an application user with limited privileges: SELECT and INSERT on the pets table
* Store these database application-credentials in Kubernetes secrets.

So we can refer to them later, export the database name and application-credentials as environment variables:

`export APPLICATION_DB_NAME=demo_app_db
export APPLICATION_DB_USER=demo_app_user
export APPLICATION_DB_INITIAL_PASSWORD=demo_app_user_password`{{execute}}

To perform the steps listed above, first create a file containing SQL commands:

`cat > sql_cmds.txt << EOSQL
    /*----------------------------------*/
    /*   Create Application Database    */
    /*----------------------------------*/
    CREATE DATABASE ${APPLICATION_DB_NAME};
    /*----------------------------------*/
    /*       Connect to Database        */
    /*----------------------------------*/
    \c ${APPLICATION_DB_NAME};
    /*----------------------------------*/
    /*       Create a pets Table        */
    /*----------------------------------*/
    CREATE TABLE pets (
      id serial primary key,
      name varchar(256)
    );
    /*----------------------------------*/
    /*     Create Application User      */
    /*----------------------------------*/
    CREATE USER ${APPLICATION_DB_USER} PASSWORD '${APPLICATION_DB_INITIAL_PASSWORD}';
    /*----------------------------------*/
    /*        Grant Permissions         */
    /*----------------------------------*/
    GRANT SELECT, INSERT ON public.pets TO ${APPLICATION_DB_USER};
    GRANT USAGE, SELECT ON SEQUENCE public.pets_id_seq TO ${APPLICATION_DB_USER};
EOSQL`{{execute}}

And then run those commands using a `postgres:9.6` container as a PostgreSQL client:

`docker run --rm -i -e PGPASSWORD=${SECURITY_ADMIN_PASSWORD} postgres:9.6 \
 psql -U ${SECURITY_ADMIN_USER} \
 "postgres://${REMOTE_DB_HOST}:${REMOTE_DB_PORT}/postgres" < sql_cmds.txt`{{execute}}

**NOTE:** You may see some duplication errors. 

<details>
  <summary>Click here to see expected output...</summary>

  ```
** Usually, the commands will run without errors:**

CREATE DATABASE
You are now connected to database "demo_app_db" as user "security_admin_user".
CREATE TABLE
CREATE ROLE
GRANT
GRANT

** However, occasionally, you may see some duplication errors that you can ignore:**

ERROR:  duplicate key value violates unique constraint "pg_database_datname_index"
DETAIL:  Key (datname)=(demo_app_db) already exists.
You are now connected to database "demo_app_db" as user "security_admin_user".
ERROR:  duplicate key value violates unique constraint "pg_type_typname_nsp_index"
DETAIL:  Key (typname, typnamespace)=(pets_id_seq, 2200) already exists.
ERROR:  role "demo_app_user" already exists
GRANT
ERROR:  tuple concurrently updated
  ```
</details>

## Create Application Credentials Secret

The application will be scoped to the demo-app-ns namespace.
To create the namespace run:

`kubectl create namespace demo-app-ns`{{execute}}

<details>
  <summary>Click here to see expected output...</summary>

  ```
namespace "demo-app-ns" created
  ```
</details>

Next we’ll store the application-credentials in Kubernetes Secrets:

`kubectl --namespace demo-app-ns \
  create secret generic demo-app-backend-credentials \
  --from-literal=host="${REMOTE_DB_HOST}" \
  --from-literal=port="${REMOTE_DB_PORT}" \
  --from-literal=username="${APPLICATION_DB_USER}" \
  --from-literal=password="${APPLICATION_DB_INITIAL_PASSWORD}"`{{execute}}

<details>
  <summary>Click here to see expected output...</summary>

  ```
secret "demo-app-backend-credentials" created
  ```
</details>

While Kubernetes Secrets are more secure than hard-coded ones, in a real deployment you should secure secrets in a fully-featured vault, like Conjur.

## Create Application Service Account and Grant Entitlements

To grant our application access to the credentials in Kubernetes Secrets, we’ll need to:
* Create a **ServiceAccount** for our application
* Create a **Role** with permissions to "get" the backend-credentials secret
* Create a **RoleBinding** so our ServiceAccount has this Role

The YAML manifest to create these resources can be viewed here: [application-entitlements.yml](application-entitlements.yml)

To create the Kubernetes resources, run this command:
`kubectl --namespace demo-app-ns apply -f demo-app-entitlements.yml`{{execute}}

<details>
  <summary>Click here to see expected output...</summary>

  ```
serviceaccount/demo-app-svc-account created
role.rbac.authorization.k8s.io/backend-credentials-reader created
rolebinding.rbac.authorization.k8s.io/read-backend-credentials created
  ```
</details>

## Up next...

Continue as a Security Admin and configure Secretless Broker.


The last task for the administrator is to prepare Conjur for Secretless Broker Sidecar.
Documentation can be found [here](https://docs.conjur.org/Latest/en/Content/Get%20Started/scl_using-conjur-OSS.htm?tocpath=Integrations%7COpenShift%252C%20Kubernetes%7CDeploy%20Applications%7C_____2#AddyourapplicationtoConjurpolicy).

## Review the env setup

The table below summarizes what we have set up so far:

| Info                                       | Value                   | How we refer it                |
|--------------------------------------------|-------------------------|--------------------------------|
| Policy branch with target credentials      | app/testapp/secret      | ${APP_SECRETS_POLICY_BRANCH}   |
| Layer/group with access to secrets         | app/testapp/layer       | ${APP_SECRETS_READER_LAYER}    |
| Kubernetes authenticator name              | dev                     | ${AUTHENTICATOR_ID}            |
| Conjur instance Kubernetes namespace       | conjur-server           | ${OSS_CONJUR_NAMESPACE}        |
| Conjur instance Kubernetes service account | conjur-cluster          | ${CONJUR_SERVICE_ACCOUNT_NAME} |
| Conjur URL                                 | https://conjur.demo.com | ${CONJUR_APPLIANCE_URL}        |
| Conjur Account                             | default                 | ${CONJUR_ACCOUNT}              |
| Conjur Admin Login                         | admin                   | ${CONJUR_ADMIN_AUTHN_LOGIN}    |
| Conjur Admin API Key                       | MySecretP@ss1           | ${CONJUR_ADMIN_API_KEY}        |
| App Name                                   | testapp-secure          | ${APP_NAME}                    |
| App Namespace                              | testapp                 | ${APP_NAMESPACE}               |
| App Service Account Name                   | testapp-secure-sa       | ${APP_SERVICE_ACCOUNT_NAME}    |

## env.sh

A code snippet that contains all the variables defined in the table above has been prepared for you.
To review it, execute `cat secretless/env.sh`{{execute HOST1}}

## Add your application to Conjur policy
You can define your host using a variety of Kubernetes resources.
Use the following bash code snippet to generate the policy, named app-policy.yml, to add your application to Kubernetes:

```
. ./secretless/env.sh
cat << EOL > ./secretless/app-policy.yml
---
# Policy enabling the Kubernetes authenticator for your application
- !policy
  id: conjur/authn-k8s/${AUTHENTICATOR_ID}/apps
  body:
    - &hosts
      - !host
        id: service-account-based-app
        annotations:
          authn-k8s/namespace: ${APP_NAMESPACE}
          authn-k8s/service-account: ${APP_SERVICE_ACCOUNT_NAME}
          authn-k8s/authentication-container-name: ${APP_AUTHENTICATION_CONTAINER_NAME}
          kubernetes: "true"
    - !grant
      role: !layer
      members: *hosts
# Grant application's authn identity membership to the application secrets reader layer so authn identity inherits read privileges on application secrets
- !grant
  role: !layer ${APP_SECRETS_READER_LAYER}
  members:
  - !host /conjur/authn-k8s/${AUTHENTICATOR_ID}/apps/service-account-based-app
  
EOL
```{{execute HOST1}}

You can review the generated policy by `cat secretless/app-policy.yml`{{execute HOST1}}

Let's load the generated policy by executing:
```
conjur policy load root /root/secretless/app-policy.yml
```{{execute HOST1}}

## Grant the Conjur instance access to pods

The bash script snippet below generates a Kubernetes manifest for the following:
 - A Role with the relevant permissions.
 - A Role Binding of the application service account to the Role.

This Role and Role Binding combination grants the service account, assigned to the Conjur instance, access to pods in the application namespace.

```
. ./secretless/env.sh

cat << EOL > secretless/conjur-authenticator-role.yml
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: conjur-authenticator
  namespace: ${APP_NAMESPACE}
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods", "serviceaccounts"]
  verbs: ["get", "list"]
- apiGroups: ["extensions"]
  resources: [ "deployments", "replicasets"]
  verbs: ["get", "list"]
- apiGroups: ["apps"]  # needed on OpenShift 3.7+
  resources: [ "deployments", "statefulsets", "replicasets"]
  verbs: ["get", "list"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create", "get"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: conjur-authenticator-role-binding
  namespace: ${APP_NAMESPACE}
subjects:
  - kind: ServiceAccount
    name: ${OSS_CONJUR_SERVICE_ACCOUNT_NAME}
    namespace: ${OSS_CONJUR_NAMESPACE}
roleRef:
  kind: Role
  name: conjur-authenticator
  apiGroup: rbac.authorization.k8s.io
EOL
```{{execute HOST1}}

You can review the generated policy by `cat secretless/conjur-authenticator-role.yml`{{execute HOST1}}

Let's load the generated policy by executing:
```
kubectl create -f secretless/conjur-authenticator-role.yml
```{{execute HOST1}}


### Store the Conjur SSL certificate in a ConfigMap
The Conjur SSL certificate is avaliable as `conjur-default.pem`

Use the following code snippet to store the Conjur SSL Certificate:
```
. ./secretless/env.sh

kubectl \
  --namespace "${APP_NAMESPACE}" \
  create configmap \
  conjur-cert \
  --from-file=ssl-certificate="conjur-default.pem"
```{{execute HOST1}}

### Store the Secretless configuration in a ConfigMap
Use the following bash script snippet to generate a Secretless configuration that defines how the service connector is setup
For more information, see the [Secretless documentation](https://docs.secretless.io/)

```
. ./secretless/env.sh

cat << EOL > ./secretless/secretless.yml
version: "2"
services:
  postgres-db:
    connector: pg
    listenOn: tcp://0.0.0.0:5432
    credentials:
      host:
        from: conjur
        get: ${APP_SECRETS_POLICY_BRANCH}/host
      port:
        from: conjur
        get: ${APP_SECRETS_POLICY_BRANCH}/port
      username:
        from: conjur
        get: ${APP_SECRETS_POLICY_BRANCH}/username
      password:
        from: conjur
        get: ${APP_SECRETS_POLICY_BRANCH}/password
      sslmode: disable
EOL
```{{execute HOST1}}

After generating the Secretless configuration, store it in a ConfigMap manifest by running the following:
```
. ./secretless/env.sh

kubectl \
  --namespace "${APP_NAMESPACE}" \
  create configmap \
  secretless-config \
  --from-file=./secretless/secretless.yml
```{{execute HOST1}}

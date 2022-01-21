Next, we will enable and configure the Conjur Kubernetes Authenticator
(authn-k8s), and establish an identity in Conjur to authenticate the
application.

First, deploy a Conjur CLI pod to the Conjur namespace. We will use the CLI to
log into Conjur and run commands to set up the authenticator.

```
cat <<EOF | kubectl apply -n conjur-oss -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: conjur-cli
  labels:
    app: conjur-cli
spec:
  replicas: 1
  selector:
    matchLabels:
      app: conjur-cli
  template:
    metadata:
      name: conjur-cli
      labels:
        app: conjur-cli
    spec:
      serviceAccountName: conjur-deployment-conjur-oss
      containers:
      - name: conjur-cli
        image: cyberark/conjur-cli:5
        imagePullPolicy: Always
        command: ["sleep"]
        args: ["infinity"]
        env:
        - name: ADMIN_API_KEY
          value: ${ADMIN_API_KEY}
      imagePullSecrets:
        - name: dockerpullsecret
EOF
CLI_POD="$(kubectl get pods -n conjur-oss | grep cli | awk '{print $1}')"
kubectl wait --for=condition=ready --timeout=300s "pod/${CLI_POD}" -n conjur-oss
```{{execute}}

Once the CLI pod is running, copy policy files into the CLI container:

```
kubectl cp /policy "${CLI_POD}:/policy" -n conjur-oss
```{{execute}}

Get a shell into the CLI container:

```
kubectl exec -it "$CLI_POD" -n conjur-oss -- /bin/bash
```{{execute}}

Initialize and authenticate the CLI:

```
yes yes | conjur init -u https://conjur-deployment-conjur-oss.conjur-oss.svc.cluster.local -a myAccount
conjur authn login -u admin -p $ADMIN_API_KEY
```{{execute}}

Now that the CLI is authenticated, we need to load the following policy to
create an authn-k8s instance.
- `setup_k8s_authn.yml`
  - creates an authn-k8s webservice, `quickstart-cluster`
  - creates a group, `consumers`, with permission to authenticate to the
    webservice
- `create_host.yml`
  - creates a host identity to represent the demo application, `quickstart-app`
  - creates a group `apps` and grants the host `quickstart-app` as a member
- `app_secrets.yml`
  - creates a group of variables, `springboot-creds`, representing credentials
    to for the quickstart app's database
  - creates a group with permission to read these variables,
    `quickstart-app-resources`
- `grants.yml`
  - grants `apps` group (and by extension the host `quickstart-app`) as a member
    of groups `consumers` and `quickstart-app-resources`, allowing the host
    permission to authenticate to the webservice and read the database
    credentials

For more information on these policy files, see the documentation for
[Enabling the Kubernetes Authenticator](https://docs.conjur.org/Latest/en/Content/Integrations/Kubernetes_deployApplicationCluster.htm?tocpath=Integrations%7COpenShift%252C%20Kubernetes%7C_____4).

Load the policy files to create and configure authn-k8s:

```
conjur policy load root /policy/setup_k8s_authn.yml
conjur policy load root /policy/create_host.yml
conjur policy load root /policy/app_secrets.yml
conjur policy load root /policy/grants.yml
```{{execute}}


Add secret values to Conjur:

```
conjur variable values add quickstart-app-resources/platform 'postgres'
conjur variable values add quickstart-app-resources/url 'postgresql://pg-backend.quickstart-namespace.svc.cluster.local:5432/pg_backend'
conjur variable values add quickstart-app-resources/username 'quickstartUser'
conjur variable values add quickstart-app-resources/password 'MySecr3tP@ssword'
```{{execute}}

Exit the CLI with `exit`{{execute}}.

Now that authn-k8s has been set up in policy, initialize
the authenticator's certificate authority.

```
kubectl exec "$CONJUR_POD" -c conjur-oss -n conjur-oss \
  -- bash -c "CONJUR_ACCOUNT=myAccount rake authn_k8s:ca_init['conjur/authn-k8s/quickstart-cluster']"
```{{execute}}

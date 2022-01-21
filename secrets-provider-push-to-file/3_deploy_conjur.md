First, we will deploy Conjur Open Source on the KinD cluster using the Conjur
OSS Helm Chart.

Add the CyberArk Helm repository:

```
helm repo add cyberark https://cyberark.github.io/helm-charts
helm repo update
```{{execute}}

Once the repo is added, the following command will deploy Conjur Open Source,
create an account `myAccount`, and enable a Kubernetes Authenticator
`quickstart-cluster`:

```
helm install -n conjur-oss --create-namespace --wait --timeout 300s \
  --set dataKey="$(docker run --rm cyberark/conjur data-key generate)" \
  --set account.name="myAccount" --set account.create="true" \
  --set authenticators="authn\,authn-k8s/quickstart-cluster" \
  --set service.external.enabled="false" \
  conjur-deployment cyberark/conjur-oss
```{{execute}}

When the terminal outputs the following, Conjur has been successfully deployed,
and we can continue:

```
 . . .

4. Next Steps
  - Go through the Conjur Tutorials: https://www.conjur.org/tutorials/
  - View Conjur's API Documentation: https://www.conjur.org/api.html
$
```

Now, retrieve the API key for user `admin`:

```
CONJUR_POD="$(kubectl get pods -n conjur-oss | grep conjur-oss | awk '{print $1}')"
ADMIN_API_KEY="$(kubectl exec $CONJUR_POD \
  --container="conjur-oss" -n conjur-oss \
  -- conjurctl role retrieve-key myAccount:user:admin | tail -1)"
```{{execute}}

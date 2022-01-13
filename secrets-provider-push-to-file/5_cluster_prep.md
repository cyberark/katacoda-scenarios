Next, prepare the Kubernetes cluster and an application namespace with the
Conjur Configuration Helm charts.

Retrieve a SSL certificate from Conjur using the script `get-conjur-cert.sh`.
This script can be downloaded from the Conjur Kubernetes Authenticator's
[GitHub releases](https://github.com/cyberark/conjur-authn-k8s-client/releases/tag/v0.22.0),
but for the purposes of this quick-start, it has been included as
`/usr/local/bin/get-conjur-cert.sh`.

```
/usr/local/bin/get-conjur-cert.sh -v -i -s -u "https://conjur-deployment-conjur-oss.conjur-oss.svc.cluster.local" -f "./conjur-certificate.pem"
```{{execute}}

Now, use the retrieved certificate to install the Cluster Preparation Helm
chart. This Helm chart creates:
- a "Golden" ConfigMap, containing a reference of Conjur connection and
  configuration details.
- an Authenticator ServiceAccount, which is used as a K8s identity by the Conjur
  authenticator.
- an Authenticator ClusterRole, which provides a list of K8s API access
  permissions that the authenticator requires.

```
helm install cluster-prep-chart cyberark/conjur-config-cluster-prep -n conjur-oss \
  --set conjur.account="myAccount" \
  --set conjur.applianceUrl="https://conjur-deployment-conjur-oss.conjur-oss.svc.cluster.local" \
  --set conjur.certificateBase64="$(cat ./conjur-certificate.pem | base64 --wrap=0)" \
  --set authnK8s.authenticatorID="quickstart-cluster" \
  --set authnK8s.clusterRole.name="conjur-clusterrole"
```{{execute}}

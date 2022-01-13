Create and prepare the application namespace for Conjur Kubernetes
Authentication with the Namespace Preparation Helm chart. This
Helm chart creates:
- a Conjur connection ConfigMap, containing references to credentials stored in
  the "Golden" ConfigMap.
- an Authenticator RoleBinding, which grants permissions to the authenticator
  ServiceAccount.

```
helm install namespace-prep-chart cyberark/conjur-config-namespace-prep \
  -n quickstart-namespace --create-namespace \
  --set authnK8s.goldenConfigMap="conjur-configmap" \
  --set authnK8s.namespace="conjur-oss"
```{{execute}}

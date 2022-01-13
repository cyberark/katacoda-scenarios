Now we are going to deploy a demo application, which will consume the secrets
file written to the shared volume by Secrets Provider.

Take a look at the application manifest with
`cat /manifests/app_manifest.yml`{{execute}},
and there are a few aspects to note:

The deployment consists of two containers: a Secrets Provider init container,
and a Pet Store demo application that will consume the secret file to connect to
the Postgres database we deployed earlier.

Secrets Provider in Push-to-File mode is configured with Pod annotations, named
as `conjur.org/<setting>`. A full reference for these settings can be found in
the [Push-to-File documentation](https://github.com/cyberark/secrets-provider-for-k8s/blob/main/PUSH_TO_FILE.md#reference-table-of-configuration-annotations). Important ones to note:
- `conjur.org/secrets-destination` enables Push-to-File.
- `conjur.org/authn-identity` defines the Conjur identity the application is
  using to authenticate.
- `conjur.org/conjur-secrets.test-app` defines Conjur variables that will be
  rendered in the resulting secret file.

There are three required volumes:
1. `podinfo`: This volume will contain a file, created by the K8s Downward
   API, containing configuration data from the Pod annotations. This volume
   needs to be mounted in the Secrets Provider container.
2. `conjur-templates`: Secrets Provider allows for customizing secret files
   with custom templates. This volume will contain custom template files
   defined in ConfigMaps, and needs to be mounted to the Secrets Provider
   container.
3. `conjur-secrets`: This volume will contain secret files created by Secrets
   Provider, and needs to be mounted to both the Secrets Provider and
   application containers.
  

Deploy the application:

```
kubectl apply -n quickstart-namespace -f /manifests/app_manifest.yml
APP_POD="$(kubectl get pods -n quickstart-namespace | grep quickstart-app | awk '{print $1}')"
kubectl wait --for=condition=ready --timeout=300s "pod/${APP_POD}" -n quickstart-namespace
```{{execute}}

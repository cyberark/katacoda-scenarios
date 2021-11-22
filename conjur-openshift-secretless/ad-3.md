
## Review the files

Let's review the application manifest file:
`cat secretless/testapp-secure.yml`{{execute}}

And the info for application deployment:
`cat secretless/developer-env.sh`{{execute}}

Can you find any embedded secret?

No, there is no more embedded secret!

## The Magic

How is it possible?   Let's take a closer look at the log from secretless broker
`oc logs $(oc get pods --namespace testapp -l "app=testapp-secure"  -o jsonpath="{.items[0].metadata.name}") secretless`{{execute}}

```
2021/11/22 01:45:55 [INFO]  Starting TCP listener on 0.0.0.0:5432...
2021/11/22 01:45:55 [INFO]  postgres-db: Starting service
2021/11/22 01:45:59 Instantiating provider 'conjur'
2021/11/22 01:45:59 Info: Conjur provider using Kubernetes authenticator-based authentication
2021/11/22 01:45:59 Info: Conjur provider is authenticating as host/conjur/authn-k8s/dev/apps/service-account-based-app ...
INFO:  2021/11/22 01:45:59.816954 authenticator.go:207: CAKC040 Authenticating as user 'host/conjur/authn-k8s/dev/apps/service-account-based-app'
INFO:  2021/11/22 01:46:01.060175 authenticator.go:229: CAKC035 Successfully authenticated
```

The secretless broker makes use of `service-account-based-app` for authentication, which is based on the service account `testapp-secure-sa` & authentication container name `secretless` used by our app on OpenShift.

To review the policy, execute `cat secretless/app-policy.yml`{{execute}}

```
- !host
id: service-account-based-app
annotations:
    authn-k8s/namespace: testapp
    authn-k8s/service-account: testapp-secure-sa
    authn-k8s/authentication-container-name: secretless
```

Conjur supports other Kubernetes resources/objects as app identities, including `Namespace`, `Deployment`, `DeploymentConfig`, `StatefulSet` , etc.   Please refer to https://docs.cyberark.com/Product-Doc/OnlineHelp/AAM-DAP/Latest/en/Content/Integrations/k8s-ocp/k8s-app-identity.htm for more details.
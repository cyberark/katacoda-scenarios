

Let's update the application policy.   
Instead of using secretless as the authentication-container-name, we will add a new one, authenticator 


```
cat > secretless/app-policy.yml<<EOF
---
# Policy enabling the Kubernetes authenticator for your application
- !policy
  id: conjur/authn-k8s/dev/apps
  body:
    - &hosts
      - !host
        id: service-account-based-app
        annotations:
          authn-k8s/namespace: testapp
          authn-k8s/service-account: testapp-secure-sa
          authn-k8s/authentication-container-name: secretless
          kubernetes: "true"
      - !host
        id: service-account-based-app-using-authenticator
        annotations:
          authn-k8s/namespace: testapp
          authn-k8s/service-account: testapp-secure-sa
          authn-k8s/authentication-container-name: authenticator
          kubernetes: "true"
    - !grant
      role: !layer
      members: *hosts
# Grant application's authn identity membership to the application secrets reader layer so authn identity inherits read privileges on application secrets
- !grant
  role: !layer app/testapp/layer
  members:
  - !host /conjur/authn-k8s/dev/apps/service-account-based-app
  - !host /conjur/authn-k8s/dev/apps/service-account-based-app-using-authenticator

EOF
```{{execute}}

To update the policy, execute:

```
conjur policy load -b root -f secretless/app-policy.yml
```{{execute}}


## Do you know?

Conjur supports other Kubernetes resources/objects as app identities, including `Namespace`, `Deployment`, `DeploymentConfig`, `StatefulSet` , etc.   Please refer to https://docs.cyberark.com/Product-Doc/OnlineHelp/AAM-DAP/Latest/en/Content/Integrations/k8s-ocp/k8s-app-identity.htm for more details.
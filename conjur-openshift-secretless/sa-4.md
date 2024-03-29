

Let's enable the kubenetes authenicator for application deployment.

The following procedures are covered in this step.
1. Policy
2. Initalize CA
3. Configure Authenticator

We will use the following configuration in this tutorial:

| Configuration    | Value   |
|------------------|---------|
| AUTHENTICATOR_ID | dev     |
| CONJUR_ACCOUNT   | default |
| TEST_APP_NAMESPACE_NAME | testapp
| APPLICATION_SERVICE_ACCOUNT | testapp-secure-sa |
| AUTHENTICATOR_CLIENT_CONTAINER_NAME | secretless |

For details, please refer to the [Conjur official doc](https://docs.conjur.org/Latest/en/Content/Integrations/Kubernetes_deployApplicationCluster.htm?tocpath=Integrations%7COpenShift%252C%20Kubernetes%7C_____4)

## Policy

### Policy for human users

At least one user needs write permission to load policy and variables into Conjur. This is standard Conjur policy that creates an administrative group of users for Conjur.
A sample policy is prepared.
To review it, execute: `cat conjur/policy_for_human_users.yml`{{execute}}

### Policy for authentication identities

The identities that will be used to authenticate and retrieve secrets from Conjur will also need to be defined in policy and added to the layer that was granted access to the Kubernetes authenticator webservice in the previous policy.

For details about the different identities that can be used in this policy, see [Application Identity in OpenShift/Kubernetes](https://docs.conjur.org/Latest/en/Content/Integrations/Kubernetes_AppIdentity.htm)

A sample policy is prepared.
To review it, execute: `cat conjur/policy_for_authenticator_identities.yml`{{execute}}

### Policy for the Kubernetes authenticator service

Conjur uses policy to allowlist the applications that have access to the Kubernetes authenticator and store the values necessary to create client certificates for mutual TLS
A sample policy is prepared.
To review it, execute: `cat conjur/policy_for_k8s_authenticator_service.yml`{{execute}}


### Load Policies into Conjur

To load all 3 policies into Conjur, execute:

```
conjur policy load -b root -f conjur/policy_for_human_users.yml && \
conjur policy load -b root -f conjur/policy_for_authenticator_identities.yml && \
conjur policy load -b root -f conjur/policy_for_k8s_authenticator_service.yml 
```{{execute}}


## Initalize CA

The [Policy for the Kubernetes authenticator service](https://docs.conjur.org/Latest/en/Content/Integrations/Kubernetes_deployApplicationCluster.htm?tocpath=Integrations%7COpenShift%252C%20Kubernetes%7C_____4#Define2) declares variables to hold a CA certificate and key.

To create the script, execute:

```

cat <<'EOF' >> initialize_ca.sh

#!/bin/bash
#set -e
AUTHENTICATOR_ID='dev'
CONJUR_ACCOUNT='default'

# Generate OpenSSL private key
openssl genrsa -out ca.key 2048

CONFIG="
[ req ]
distinguished_name = dn
x509_extensions = v3_ca
[ dn ]
[ v3_ca ]
basicConstraints = critical,CA:TRUE
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer:always
"

# Generate root CA certificate
openssl req -x509 -new -nodes -key ca.key -sha1 -days 3650 -set_serial 0x0 -out ca.cert \
  -subj "/CN=conjur.authn-k8s.$AUTHENTICATOR_ID/OU=Conjur Kubernetes CA/O=default" \
  -config <(echo "$CONFIG")

# Verify cert
openssl x509 -in ca.cert -text -noout

# Load variable values
conjur variable set -i conjur/authn-k8s/$AUTHENTICATOR_ID/ca/key -v "$(cat ca.key)"
conjur variable set -i conjur/authn-k8s/$AUTHENTICATOR_ID/ca/cert -v "$(cat ca.cert)"
EOF
```{{execute}}



To initialize the CA, execute: 
```
source ./initialize_ca.sh
```{{execute}}

## Configure Conjur authenticators

We have already configured the conjur authenicators during Conjur setup!

To verify, execute 
```
export POD_NAME=$(oc get pods --namespace conjur-server \
   -l "app=conjur-oss" \
   -o jsonpath="{.items[0].metadata.name}")
oc exec --namespace conjur-server  $POD_NAME  --container=conjur-oss -- env | grep CONJUR_AUTHENTICATORS
```{{execute}}

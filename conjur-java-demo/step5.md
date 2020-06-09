# Uploading and loading in policies to Conjur
**Continuing as the Security Admin.**

In this section, we will set up our policies using predefined templates, and then execute some commands to load our policies, create configuration maps, and add our secrets to be fetched later.

1. Copy our policies from our lcoal machine to the Conjur CLI pod

   First, we can copy our policies and scripts from our local machine and into our Conjur CLI pod. We will need to add these policies to configure our certificates and secure Conjur.

   `kubectl cp policy "$CONJUR_CLI_POD":/`{{execute}}

   `kubectl cp conjur_scripts "$CONJUR_CLI_POD":/`{{execute}}

2. Upload and load in the policies using the Conjur CLI.

   First, we'll add our `policy-hosts-to-authenticate.yaml` policy, which defines a layer of whitelisted identities permitted to authenticate to the authn-k8s endpoint.

   `kubectl exec -it "$CONJUR_CLI_POD" conjur policy load root policy/policy-hosts-to-authenticate.yaml`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
    Loaded policy 'root'
    {
      "created_roles": {
        "demo-account:host:conjur/authn-k8s/demo-authenticator/apps/demo-java-client/*/*": {
          "id": "demo-account:host:conjur/authn-k8s/demo-authenticator/apps/demo-java-client/*/*",
          "api_key": <api-key>
        }
      },
      "version": 1
    }
     ```
   </details>

   The `policy-for-webservices.yaml` file defines an authn-k8s endpoint, Certificate Authority credentials and a layer for whitelisted identities permitted to authenticate to it.

   `kubectl exec -it "$CONJUR_CLI_POD" conjur policy load root policy/policy-for-webservice.yaml`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
    Loaded policy 'root'
    {
      "created_roles": {
      },
      "version": 2
    }
     ```
   </details>

   The `policy-for-variables.yaml` file allows us to store database credentials in variables and provides access to those credentials to the application identity layer.

   `kubectl exec -it "$CONJUR_CLI_POD" conjur policy load root policy/policy-for-variables.yaml`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
    Loaded policy 'root'
    {
      "created_roles": {
      },
      "version": 3
    }
     ```
   </details>

3. Adding our secret value

   Next, we will add our variable value, where the variable is ***mypassword*** and its value is ***123***.

  `kubectl exec -it "$CONJUR_CLI_POD" conjur variable values add variables/mypassword 123`{{execute}}

  <details>
    <summary>Click here to see expected output...</summary>
    ```
    Value added
    ```
  </details>

4. Create certificates and config map

   The Policy for the Kubernetes authenticator service declares variables to hold a CA certificate and key.

  `kubectl exec -it "$CONJUR_CLI_POD" ./conjur_scripts/cert_script.sh $ACCOUNT_NAME $AUTHENTICATOR`{{execute}}

  ```
  #!/bin/bash
  set -e
  AUTHENTICATOR_ID='<AUTHENTICATOR_ID>'
  CONJUR_ACCOUNT='<CONJUR_ACCOUNT>'

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
  -subj "/CN=conjur.authn-k8s.$AUTHENTICATOR_ID/OU=Conjur Kubernetes CA/O=$CONJUR_ACCOUNT" \
  -config <(echo "$CONFIG")

  # Verify cert
  openssl x509 -in ca.cert -text -noout

  # Load variable values
  conjur variable values add conjur/authn-k8s/$AUTHENTICATOR_ID/ca/key "$(cat ca.key)"
  conjur variable values add conjur/authn-k8s/$AUTHENTICATOR_ID/ca/cert "$(cat ca.cert)"
  ```

  The commands from this script create a private key and root certificate and store contents of those files in the variables conjur/authn-k8s/<AUTHENTICATOR>/ca/key and conjur/authn-k8s/<AUTHENTICATOR>/ca/cert.

  Login or auth calls to the webservice will fail if these resources are not properly defined in policy and initialized.

  `kubectl exec -it "$CONJUR_CLI_POD" cat /root/conjur-$ACCOUNT_NAME.pem > conjur-cert.pem`{{execute}}

    <details>
      <summary>Click here to see expected output...</summary>
      ```
      Generating RSA private key, 2048 bit long modulus (2 primes)
      .....................+++++
      ........................................+++++
      e is 65537 (0x010001)
      Value added
      Value added
      ```
    </details>

  We need to store our public SSL certificate which is generated during the Conjur applicance configuration and stored in a .pem file. We can store this value in a ConfigMap.

  `kubectl create configmap conjur-cert --from-file=ssl-certificate=conjur-cert.pem`{{execute}}

  <details>
    <summary>Click here to see expected output...</summary>
    ```
    configmap/conjur-cert created
    ```
  </details>

## Up Next...
You will play the role of the **Application Developer** and run your app in a local container that uses the authenticator sidecar to fetch our secret!

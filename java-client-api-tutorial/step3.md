# Configuring Conjur OSS

In this section, we will set up our policies using predefined templates, and then execute some commands to load our policies, create configuration maps, and add our secrets to be fetched later.

1. Set up a policy folder

   `CONJUR_CLI_POD=$( kubectl get pods | grep conjur-cli | (head -n1 && tail -n1) | cut -f 1 -d " " )
mkdir -p policy
echo -e "admin\n$API_KEY" > policy/authnInput
   `{{execute}}

2. Update the policy templates with environmental variables and add them to the policy folder

   `cat templates/policy-hosts-to-authenticate.yaml | sed s/'{{ AUTHENTICATOR }}'/$AUTHENTICATOR/g | sed s/'{{ PROJECT_NAME }}'/$PROJECT_NAME/g > policy/policy-hosts-to-authenticate.yaml
cat templates/policy-for-webservice.yaml | sed s/'{{ AUTHENTICATOR }}'/$AUTHENTICATOR/g > policy/policy-for-webservice.yaml
cat templates/policy-for-variables.yaml | sed s/'{{ AUTHENTICATOR }}'/$AUTHENTICATOR/g | sed s/'{{ PROJECT_NAME }}'/$PROJECT_NAME/g > policy/policy-for-variables.yaml
   `{{execute}}

3. Copy Conjur policies

   `kubectl cp policy "$CONJUR_CLI_POD":/
kubectl cp conjur_scripts "$CONJUR_CLI_POD":/
   `{{execute}}

4. Load in conjur policies by running these commands in the CONJUR_CLI container

  `kubectl exec -it "$CONJUR_CLI_POD" conjur init <<< "https://conjur-oss
yes
$ACCOUNT_NAME
y
"`{{execute}}

  <details>
    <summary>Click here to see expected output...</summary>
    ```
Unable to use a TTY - input is not a terminal or the right kind of file
Enter the URL of your Conjur service: Trust this certificate (yes/no): Enter your organization account name:
SHA1 Fingerprint=46:5E:BB:5F:B0:40:10:E0:47:BF:29:F0:0A:5F:A3:02:7A:B7:F4:FC
Please verify this certificate on the appliance using command:
          openssl x509 -fingerprint -noout -in ~conjur/etc/ssl/conjur.pem
Wrote certificate to /root/conjur-demo-account.pem
Wrote configuration to /root/.conjurrc
    ```
  </details>

  `kubectl exec -it "$CONJUR_CLI_POD" conjur authn login < policy/authnInput`{{execute}}

  <details>
    <summary>Click here to see expected output...</summary>
    ```
    Unable to use a TTY - input is not a terminal or the right kind of file
    Enter your username to log into Conjur: Please enter your password (it will not be echoed): stty: 'standard input': Inappropriate ioctl for device
    stty: 'standard input': Inappropriate ioctl for device
    stty: 'standard input': Inappropriate ioctl for device
    Logged in
    ```
  </details>

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

  `kubectl exec -it "$CONJUR_CLI_POD" conjur variable values add variables/mypassword 123`{{execute}}

  <details>
    <summary>Click here to see expected output...</summary>
    ```
    Value added
    ```
  </details>

5. Create certificates and config map

  `kubectl exec -it "$CONJUR_CLI_POD" ./conjur_scripts/cert_script.sh $ACCOUNT_NAME $AUTHENTICATOR`{{execute}}

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

  `kubectl delete --ignore-not-found=true configmap conjur-cert`{{execute}}

  `ssl_certificate=$(cat conjur-cert.pem )`{{execute}}

  `kubectl create configmap conjur-cert --from-literal=ssl-certificate="$ssl_certificate"`{{execute}}

  <details>
    <summary>Click here to see expected output...</summary>
    ```
    configmap/conjur-cert created
    ```
  </details>

  `kubectl delete --ignore-not-found=true configmap conjur-cert-java`{{execute}}

  `kubectl create configmap conjur-cert-java --from-file=ssl-certificate=conjur-cert.pem`{{execute}}

  <details>
    <summary>Click here to see expected output...</summary>
    ```
    configmap/conjur-cert-java created
    ```
  </details>

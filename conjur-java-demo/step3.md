# Creating a Conjur account and running the Conjur CLI

**You are now the Security Admin.**

You will create a Conjur account, and generate an API key in order to login to the Conjur CLI. You will then start up the CLI, in order to login and add your policies and configurations in the next step.

Some environment variables have been preset for the use of this tutorial:
* ACCOUNT_NAME
* AUTHENTICATOR
* DEPLOYMENT_NAME

1. Create a Conjur account and generate an API Key

   First, we need to get the name of our Conjur-OSS pod so we can create an admin account in Conjur.

   `CONJUR_OSS_POD=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep "conjur-oss" | head -n1)`{{execute}}

   We’ll create our new account called demo-account, which our Infrastructure Engineer specified as the account to be used by the Kubernetes Authenticator in `custom-values.yaml`.

   The command returns a public key and an API key for the admin user (you’ll want to back these up in a secure location).

   `CONJUR_OUTPUT_INIT=$( kubectl exec "$CONJUR_OSS_POD" --container=conjur-oss conjurctl account create $ACCOUNT_NAME )`{{execute}}

   `API_KEY=$( echo "$CONJUR_OUTPUT_INIT" |  grep "API key" | awk '{print $5}' )`{{execute}}

    We will want to use this API key later in order to login to our Conjur CLI, so we'll store it in a safe place in `policy/authnInput`.

   `echo -e "admin\n$API_KEY" > policy/authnInput`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
     Created new account 'demo-account'
     ```
   </details>

2. Run the Conjur CLI

   The Conjur CLI implements the Conjur REST API, which provides an alternate interface for managing Conjur resources such as roles, privileges, policies, and secrets. As the Security Admin, we will want to set up policies and certificates after we create an admin account and login.

   `kubectl create -f conjur-cli.yaml`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
      ```
    deployment.apps/conjur-cli created
      ```
   </details>

3. Wait for the Conjur CLI pod to run

   `kubectl get pods`{{execute}}

   <details>
     <summary>Click here to see expected output...</summary>
     ```
NAME                                   READY   STATUS    RESTARTS   AGE
conjur-cli-<pod-identifier>            1/1     Running   0          37s
conjur-oss-<pod-identifier>            2/2     Running   0          2m1s
conjur-oss-<pod-identifier>            1/1     Running   0          2m1s
     ```
   </details>

   

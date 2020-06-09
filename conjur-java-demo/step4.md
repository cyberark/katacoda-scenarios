# Initializing the Conjur CLI pod and logging into Conjur

**Continuing as the Security Admin.**

In this section, we will initialize our Conjur pod with our account name, and login to the CLI so we can later add our policies and secrets.

1. Getting the name of our Conjur CLI pod

   First, we need to get the name of our Conjur CLI pod so we can initialize Conjur.

   `CONJUR_CLI_POD=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep conjur-cli)`{{execute}}

1. Initialize the Conjur CLI

   We need to initialize the Conjur CLI in order to verify the certificate so we can login to the account we created in the previous step.

   `kubectl exec -it "$CONJUR_CLI_POD" conjur init -- --url https://conjur-oss --account $ACCOUNT_NAME`{{execute}}

   `yes`{{execute}}

  <details>
    <summary>Click here to see expected output...</summary>
    ```
Enter the URL of your Conjur service: Trust this certificate (yes/no): Enter your organization account name:
SHA1 Fingerprint=46:5E:BB:5F:B0:40:10:E0:47:BF:29:F0:0A:5F:A3:02:7A:B7:F4:FC
Please verify this certificate on the appliance using command:
          openssl x509 -fingerprint -noout -in ~conjur/etc/ssl/conjur.pem
Wrote certificate to /root/conjur-demo-account.pem
Wrote configuration to /root/.conjurrc
    ```
  </details>

2. Login to the Conjur CLI

   We’ll connect to the account we created, and log in as the admin user. The password is the API key we received when we created with the demo account and stored in `policy/authnInput`.

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

## Up next...
We will continue as the **Security Admin** to add our policies and configuration

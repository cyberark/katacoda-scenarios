

In this step, we'll preform the following steps to get Conjur up & running.

1. Create a namespace for Conjur
2. Setting up Helm
3. Create a Conjur Account
4. Setting up FQDN

## Project

To create a project for Conjur, execute:
```
oc new-project conjur-server
```{{execute HOST1}}

## Install 

We can install Conjur by the following command.
Please note that it'll take a short while.

```
DATA_KEY="$(openssl rand -base64 32)"
HELM_RELEASE=conjur-oss
helm install \
   -n "$CONJUR_NAMESPACE" \
   --set image.repository=registry.connect.redhat.com/cyberark/conjur \
   --set image.tag=latest \
   --set nginx.image.repository=registry.connect.redhat.com/cyberark/conjur-nginx \
   --set nginx.image.tag=latest \
   --set postgres.image.repository=registry.redhat.io/rhscl/postgresql-10-rhel7 \
   --set postgres.image.tag=latest \
   --set openshift.enabled=true \
   --set dataKey="$DATA_KEY" \
   --set authenticators="authn-k8s/dev" \
   --set ssl.hostname=conjur-oss-conjur-server-2886795272-443-jago05.environments.katacoda.com \
   "$HELM_RELEASE" \
   https://github.com/cyberark/conjur-oss-helm-chart/releases/download/v2.0.4/conjur-oss-2.0.4.tgz
```{{execute HOST1}}


## Service
Depends on the environment, additional steps may be required to expose the Conjur services to users.
Below are the steps for Katacoda platform:

```
cat > conjur-oss-katacoda.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: conjur-oss-katacoda
  namespace: conjur-server
spec:
  selector:
    app: conjur-oss
  ports:
    - protocol: TCP
      port: 8888
      targetPort: 8080
EOF

oc create -f conjur-oss-katacoda.yaml 
oc expose service/conjur-oss-katacoda
```{{execute HOST1}}

The system should return a long message showing how to proceed.


## Conjur Account

We'll need to get the pod name of Conjur.
```
CONJUR_ACCOUNT=default
CONJUR_NAMESPACE=conjur-server
HELM_RELEASE=conjur-oss
POD_NAME=$(oc get pods --namespace "$CONJUR_NAMESPACE" \
            -l "app=conjur-oss" \
            -o jsonpath="{.items[0].metadata.name}")		
```{{execute HOST1}}

if the following error occurs, please wait for 10 seconds and try the above command again
```
error: unable to upgrade connection: container not found ("conjur-oss")
```


...in order to create an account, let's call it `default`

```
oc exec --namespace $CONJUR_NAMESPACE \
              $POD_NAME \
              --container=conjur-oss \
              -- conjurctl account create $CONJUR_ACCOUNT | tee admin.out
```{{execute HOST1}}
 
If `error: unable to upgrade connection: container not found ("conjur-oss")` is returned, don't worry!
It just means we're faster than the computer! &#129315;	
Wait for a moment and try again.
 
It should generate unique public key & API key for admin, something simiiar to the one below. 
```
Created new account 'default'
Token-Signing Public Key: -----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0oDXDvz2QmdQYEJloDCD
k5Gd5ipLVsNf41V6Gya28fG4WcPVGhmBUlDFv8uXICBYC+8JBurcY+WF7bMWY/Oz
1xBnvLyrVvHd629bgQboMODlNZbdQppeV+m2ahBAMTahMnzYE+0YhE9ElIUoywyk
GSDnkq8z/bKMqWNSgmFMrqeR9v7bTZBHNvHGQnbFxD5Y3mE3nNErmQctl11KfyC/
cRIKGJCMRFaxQBvy8UppYKCcArrlry8qRM1VbB4v22BIpSoQI4vZZhObxmWTsOPV
hZeh/T8h8gvW8djShqiW+1I7BVS5gYI9nnMTdk/aVE91LGiCOwO2s0gpTRuv17fO
hwIDAQAB
-----END PUBLIC KEY-----
API key for admin: 54myrp3dgvwsc1x3mgpn1v8hksn33qxcnm3tt7tecryncqg2th4cdq
```
 
Please note that we've stored the public key and admin API key in `admin.out` file for demo. 
For your own environment, please keep them safe & secure.

## Conjur URL

Let's save the URL of conjur as environment variable

```
export CONJUR_URL=$(oc get route conjur-oss-katacoda -o jsonpath='{.spec.host}')
echo $CONJUR_URL
```{{execute HOST1}}

Great! Conjur is now up & running.
Let's setup the Conjur client

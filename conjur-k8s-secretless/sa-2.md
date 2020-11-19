

In this step, we'll preform the following steps to get Conjur up & running.

1. Create a namespace for Conjur
2. Setting up Helm
3. Create a Conjur Account
4. Setting up FQDN

## Namespace

To create a namespace for Conjur, execute:
```
kubectl create namespace conjur-server
```{{execute HOST1}}


## Helm 

Let's install Conjur using Helm.

First, we need to add `cyberark` repo to Helm
```
helm repo add cyberark https://cyberark.github.io/helm-charts
```{{execute HOST1}}

The response should look like this:
```
"cyberark" has been added to your repositories
```
Try the above command again if it shows something else

Then we'll update the repo
```
helm repo update
```{{execute HOST1}}

```
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "cyberark" chart repository
Update Complete. ⎈ Happy Helming!⎈
```
Try the above command again if it shows something else


Next, we need to add a role binding

```
kubectl apply -f conjur/role-binding.yaml
```{{execute HOST1}}
```
rolebinding.rbac.authorization.k8s.io/conjur-server-authn-role-binding created
```


Lastly, we can install Conjur by the following command.
Please note that it'll take a short while.

```
helm install conjur-cluster cyberark/conjur-oss \
     --set ssl.hostname=conjur.demo.com,dataKey="$(docker run --rm cyberark/conjur data-key generate)",authenticators="authn-k8s/dev" \
     --set postgres.persistentVolume.create=false \
     --set service.external.enabled=false \
     --namespace conjur-server
```{{execute HOST1}}

The system should return a long message showing how to proceed.


## Conjur Account

We'll need to get the pod name of Conjur.
```
 export POD_NAME=$(kubectl get pods --namespace conjur-server \
   -l "app=conjur-oss,release=conjur-cluster" \
   -o jsonpath="{.items[0].metadata.name}")
```{{execute HOST1}}

if the following error occurs, please wait for 10 seconds and try the above command again
```
error: unable to upgrade connection: container not found ("conjur-oss")
```


...in order to create an account, let's call it `default`

```
kubectl exec --namespace conjur-server \
    $POD_NAME \
  --container=conjur-oss \
  -- conjurctl account create "default" | tee admin.out
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

## FQDN

Let's give our setup a Fully qualified domain name (FQDN) - `conjur.demo.com`
Typically we will configure it in the DNS system.
This time, for demo purpose, we'll simply update the `/etc/hosts` file

```
export CONJUR_URL=$(kubectl describe svc conjur-cluster-conjur-oss -n conjur-server |grep Endpoints | awk '{print $2}')
export SERVICE_IP=$(echo $CONJUR_URL | awk  -F ':' '{print $1}')
echo $SERVICE_IP
```{{execute HOST1}}

An IP address should be displayed.   If not, that means the service is starting.
please wait for a moment and repeat the above step again.

Once the service IP is ready, let's add it to the `/etc/hosts` file

```
echo "$SERVICE_IP conjur.demo.com" >> /etc/hosts
```{{execute HOST1}}

Great! Conjur is now up & running.
Let's setup the Conjur client

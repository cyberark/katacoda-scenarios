

In a Secretless Broker deployment, when a client needs access to a Target Service it doesn't try to make a direct connection. Instead, it sends the request through its Secretless Broker.

![secretless broker](https://docs.conjur.org/Latest/en/Content/Resources/Images/secretless_architecture.svg)

The following procedures are covered in this step:

1. Add the secrets to Conjur
2. Add the app to Conjur policy
3. Grant Conjur access to the pods in app namespace
4. Store Conjur SSL cert in a Config Map

## Add the secrets to Conjur

We'll create a layer, create 4 variables as secrets, and grant the layer to access all the variables.

```
curl -k -s -H "Authorization: Token token=\"${access_token}\"" \
   -X PATCH -d "$(< secretless/testapp-policy.yml )" \
   https://${CONJUR_URL}/policies/default/policy/root \
   | jq . 
```{{execute}}


Now let's save the secrets in Conjur

```
source conjur-authn.sh && \
curl -k -s -H "Authorization: Token token=\"${access_token}\"" \
     -X POST --data "5b3e5f75cb3cdc725fe40318" \
     https://${CONJUR_URL}/secrets/default/variable/app%2Ftestapp%2Fsecret%2Fpassword | jq .  && \
curl -k -s -H "Authorization: Token token=\"${access_token}\"" \
     -X POST --data "test_app" \
     https://${CONJUR_URL}/secrets/default/variable/app%2Ftestapp%2Fsecret%2Fusername | jq .  && \
curl -k -s -H "Authorization: Token token=\"${access_token}\"" \
     -X POST --data "testapp-db.testapp.svc.cluster.local" \
     https://${CONJUR_URL}/secrets/default/variable/app%2Ftestapp%2Fsecret%2Fhost | jq .
```{{execute}}

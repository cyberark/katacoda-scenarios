

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
conjur policy load -b root -f secretless/testapp-policy.yml
```{{execute}}


Now let's save the secrets in Conjur

```
conjur variable set -i app/testapp/secret/password -v "5b3e5f75cb3cdc725fe40318" && \
conjur variable set -i app/testapp/secret/username -v "test_app" && \
conjur variable set -i app/testapp/secret/host -v "testapp-db.testapp.svc.cluster.local" && \
conjur variable set -i app/testapp/secret/port -v "5432"
```{{execute}}

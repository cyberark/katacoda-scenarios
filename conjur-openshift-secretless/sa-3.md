

In this section, we'll configure the following items for setting up the Conjur client:

1. Script for REST API
2. Testing


## Alias for Conjur CLI


In this tutorial, we will make use of the latest Conjur CLI client to communicate with Conjur via REST API
For other clients, please be sure to check out our official doc.

```
cat <<'EOF' >> conjur-authn.sh
response=$(curl -k -s -X POST https://${CONJUR_URL}/authn/default/admin/authenticate -d $(grep admin admin.out | cut -c20-) )
export access_token=$(echo -n $response | base64 | tr -d '\r\n')
EOF
chmod +x conjur-authn.sh
```{{execute}}


## Verify

To verify, we can execute the following REST API call to Conjur to get our identity

```
source conjur-authn.sh && curl -k -s -H "Authorization: Token token=\"${access_token}\"" https://$CONJUR_URL/whoami
```{{execute}}

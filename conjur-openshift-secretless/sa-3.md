

In this section, we'll configure the following items for setting up the Conjur client:

1. Script for REST API
2. Testing


## Alias for Conjur CLI

Conjur CLI client can be either installed as [Ruby gem](https://docs.conjur.org/Latest/en/Content/Tools/CLI_Install_CLI.htm?tocpath=Setup%7C_____2#ruby-gem) or [Docker Container](https://docs.conjur.org/Latest/en/Content/Tools/CLI_Install_CLI.htm?tocpath=Setup%7C_____2#docker-container).

In this tutorial, we will make use of shell scripts to communicate with Conjur via REST API

```
cat <<'EOF' >> conjur-authn.sh
response=$(curl -k -s -X POST https://${CONJUR_URL}/authn/default/admin/authenticate -d $(grep admin admin.out | cut -c20-) )
export access_token=$(echo -n $response | base64 | tr -d '\r\n')
EOF
chmod +x conjur-authn.sh
```{{execute HOST1}}


## Verify

To verify, we can execute the following REST API call to Conjur to get our identity

```
source conjur-authn.sh && curl -k -s -H "Authorization: Token token=\"${access_token}\"" https://$CONJUR_URL/whoami
```{{execute HOST1}}


### Create a policy file

Let's prepare a simple policy to get started

```
cat > conjur.yml << EOF
- !policy
  id: db

- !policy
  id: frontend
EOF
```{{execute}}

### Load/Replace policies 

Loads or replaces a Conjur policy document.

Any policy data which already exists on the server but is not explicitly specified in the new policy file will be deleted.

Note: entity IDs must be URL-encoded
Any identifier included in the URL must be URL-encoded to be recognized by the Conjur API.

```
source showSettings.sh && curl -s -H "Authorization: Token token=\"${access_token}\"" \
     -X PUT -d "$(< conjur.yml)" \
     https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/policies/demo/policy/root \
     | jq .
```{{execute}}


### Append policies 
Adds data to the existing Conjur policy. Deletions are not allowed. Any policy objects that exist on the server but are omitted from the policy file will not be deleted and any explicit deletions in the policy file will result in an error.

Note: entity IDs must be URL-encoded 
Any identifier included in the URL must be URL-encoded to be recognized by the Conjur API.

Let's prepare the first part of `db` policy
```
cat > db1.yml << EOF
- &variables
  - !variable password
EOF
```{{execute}}

And load it to Conjur
```
source showSettings.sh && curl -s -H "Authorization: Token token=\"${access_token}\"" \
     -X POST -d "$(< db1.yml)" \
     https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/policies/demo/policy/db \
     | jq .
```{{execute}}

Please note the result said the version is 1
```
{
  "created_roles": {},
  "version": 1
}
```

Now let's prepare the 2nd part of the policy file

```
cat > db2.yml << EOF
- !group secrets-users

- !permit
  resource: *variables
  privileges: [ read, execute ]
  roles: !group secrets-users
EOF
```{{execute}}

And load it to Conjur
```
source showSettings.sh && curl -s -H "Authorization: Token token=\"${access_token}\"" \
     -X POST -d "$(< db2.yml)" \
     https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/policies/demo/policy/db \
     | jq .
```{{execute}}


The policy version is now 2
```
{
  "created_roles": {},
  "version": 2
}
```


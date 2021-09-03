With the preceding steps completed, we now have the following objects and permissions in place:

- `variable:db/password` is created and populated with a value.
- `group:db/secrets-users` can “read” and “execute” the database password.
- `layer:frontend` is created, and `host:frontend/frontend-01` exists and belongs to the layer. We have an API key for it, so we can authenticate as this host.

When a frontend application is deployed to host:frontend/frontend-01, it can authenticate with the api_key printed above and attempt to fetch the db password. You can simulate this using the following CLI command:

```
export frontend_api=$(tail -n +2 frontend.out | jq -r '.created_roles."quick-start:host:frontend/frontend-01".api_key')
docker exec \
  -e CONJUR_AUTHN_LOGIN=host/frontend/frontend-01 \
  -e CONJUR_AUTHN_API_KEY=$frontend_api \
   conjur_client \
  conjur variable value db/password
```{{execute}}
```
error: 404 Not Found
```
Is the “error: 404 Not Found” a mistake? No, it’s demonstrating that the host is able to authenticate, but it’s not permitted to fetch the secret.

What’s needed is an entitlement to grant group:db/secrets-users to layer:frontend. You can verify that this role grant does not yet exist by listing the members of the role group:db/secrets-users:


`docker-compose exec client conjur role members group:db/secrets-users`{{execute}}
```
[
  "quick-start:policy:db"
]
```
And by listing the role memberships of the host:

`docker-compose exec client conjur role memberships host:frontend/frontend-01`{{execute}}
```
[
  "quick-start:host:frontend/frontend-01",
  "quick-start:layer:frontend"
]
```
Add the role grant by updating policy “db.yml” to the following:

<pre class="file" data-filename="db.yml" data-target="replace">- &variables
  - !variable password

- !group secrets-users

- !permit
  resource: *variables
  privileges: [ read, execute ]
  roles: !group secrets-users

# Entitlements
- !grant
  role: !group secrets-users
  member: !layer /frontend
</pre>

Note: You can create this file, either by clicking above "Copy to Editor" or executing `cp /root/db2.bak /root/db.yml`{{execute}}

Then load it using the CLI:

```
docker cp /root/db.yml conjur_client:db.yml
docker-compose exec client conjur policy load db db.yml
```{{execute}}

```
Loaded policy 'db'
{
  "created_roles": {
  },
  "version": 2
}
```
Now you can verify that the policy has taken effect. We will look at this in several different ways. First, verify that layer:frontend has been granted the role group:db/secrets-users:


`docker-compose exec client conjur role members group:db/secrets-users`{{execute}}
```
[
  "quick-start:policy:db",
  "quick-start:layer:frontend"
]
```
And, you can see that the host:frontend/frontend-01 has execute privilege on variable:db/password:


`docker-compose exec client conjur resource permitted_roles variable:db/password execute`{{execute}}
```
[
  "quick-start:host:frontend/frontend-01",
  "quick-start:group:db/secrets-users",
  "quick-start:policy:frontend",
  "quick-start:policy:db",
  "quick-start:layer:frontend",
  "quick-start:user:admin"
]
```
The important line here is `quick-start:host:frontend/frontend-01`

Now we can finish the tutorial by fetching the password while authenticated as the host:

```
docker exec \
  -e CONJUR_AUTHN_LOGIN=host/frontend/frontend-01 \
  -e CONJUR_AUTHN_API_KEY=$frontend_api \
   conjur_client \
  conjur variable value db/password
```{{execute}}
`926c6e5622889763c9490ca3` <- Password printed here.
Success! The host has the necessary (and minimal) set of privileges it needs to fetch the database password.


Now let's review the policy for rotating, or updating, a secret.

`docker-compose exec client conjur resource permitted_roles variable:db/password update`{{execute}}

```
[
  "quick-start:user:admin",
  "quick-start:policy:db"
]
```

As you may notice, secrets-users group is not included, so frontend-01 should not be able to modify the secrets.

Let's verify it by trying to add a new value using frontend-01's host identity:

```
docker exec \
  -e CONJUR_AUTHN_LOGIN=host/frontend/frontend-01 \
  -e CONJUR_AUTHN_API_KEY=$frontend_api \
   conjur_client \
   conjur variable values add db/password $(openssl rand -hex 12)
```{{execute}}

```
error: 403 Forbidden
```

One would be led to believe that the 403 Forbidden error is an issue. However, if you remember back to the policy we loaded for `host/frontend/frontend-01`, the host identity should only be able to `read` and `execute` on the secret variable. It shouldn't be able to update the secret variable's value.
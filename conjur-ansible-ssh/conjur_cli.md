
### Initlize CLI

Let's configure Conjur CLI to point to the newly created Conjur.
You only need to do it once

```
docker-compose exec client bash -c "echo yes | conjur init -u https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/ -a demo"
```{{execute}}

If the above command returns an error message, that means the system is being started.
Please wait for a moment and try again.


### Login to Conjur

Let's login to Conjur
```
api_key="$(grep API admin.out | cut -d: -f2 | tr -d ' \r\n')"
docker-compose exec client conjur authn login -u admin -p "$api_key"
```{{execute}}

Please note that in this tutorial, we have saved `api_key` in `admin.out` file and as `api_key` environment variable.
In production, please keep the `api_key` in a safe location

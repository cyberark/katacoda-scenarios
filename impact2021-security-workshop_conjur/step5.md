For this example, the “frontend” policy will simply define a Layer and a Host. Create the following file as “frontend.yml”:

<pre class="file" data-filename="frontend.yml" data-target="replace">
- !layer

- !host frontend-01

- !grant
  role: !layer
  member: !host frontend-01
</pre>

You can create this file, either by clicking above "Copy to Editor" or executing `cp /root/frontend.bak /root/frontend.yml`{{execute}}

> **Note** Statically defining the hosts in a policy is appropriate for fairly static infrastructure. More dynamic systems such as auto-scaling groups and containerized deployments can be managed with Conjur as well. The details of these topics are covered elsewhere.

Now load the frontend policy using the following command:


```
docker cp /root/frontend.yml conjur_client:frontend.yml
docker-compose exec client conjur policy load frontend frontend.yml | tee frontend.out
```{{execute}}

```
Loaded policy 'frontend'
{
  "created_roles": {
    "quick-start:host:frontend/frontend-01": {
      "id": "quick-start:host:frontend/frontend-01",
      "api_key": "1wgv7h2pw1vta2a7dnzk370ger03nnakkq33sex2a1jmbbnz3h8cye9"
    }
  },
  "version": 1
}
```

> **Note** The api_key printed above is a unique securely random string for each host. When you load the policy, you'll see a different API key. Be sure and use this API key in the following examples, instead of the value shown in this tutorial.

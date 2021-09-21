The first step to implementing this improvement is to create the layer resource, as shown below:

```
- !policy
  id: azureApps
  body:
    - !layer
      id: azureAppsLayer

    - !grant
      role: !layer azureAppsLayer
      members:
        - !host /azure-apps/ConjurDemoAccessFunctionSystemAssigned
        - !host /azure-apps/ConjurDemoAccessFunctionUserAssigned
```

Let's explore this from the top of the policy file:

<pre class="file" data-filename="myLayerPolicy.yml" data-target="replace">- !policy
  id: azureApps
  body:
    - !layer
      id: azureAppsLayer
</pre>

The `!layer` tag creates the layer resource 

<pre class="file" data-filename="myLayerPolicy.yml" data-target="append">    - !grant
      role: !layer azureAppsLayer
      members:
        - !host /azure-apps/ConjurDemoAccessFunctionSystemAssigned
        - !host /azure-apps/ConjurDemoAccessFunctionUserAssigned
</pre>

and the `!grant` tag associates the two hosts with this layer. The host names start with `/azure-apps` to indicate that the hosts are defined in a separate policy stored at the “root” level. If we did not include the leading slash, Conjur would throw an error because it would look for a host defined in the `azureApps` policy.

Let's load this policy using the following command:

```
docker cp /root/policy/myLayerPolicy.yml root_client_1:/root
docker-compose exec client conjur policy load root /root/myLayerPolicy.yml
```{{execute}}

If it loaded successfully, you should receive the following response:

```
Loaded policy 'root'
{
  "created_roles": {
  },
  "version": 5
}
```
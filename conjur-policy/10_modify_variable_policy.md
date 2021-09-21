The final step is to break the relationship between the variables and the hosts. We need to replace the current `secrets` policy with an updated version that removes the `!grant` tag and changes the `!permit` tag to give `read` and `execute` privileges to the layer resource we just created.

<pre class="file" data-filename="myVariablePolicy.yml" data-target="replace">- !policy
  id: secrets
  body:
    - !variable endpoint
    - !variable authKey

    - !permit
      resource: !variable endpoint
      role: !layer /azureApps/azureAppsLayer
      privilege: [ read, execute ]

    - !permit
      resource: !variable authKey
      role: !layer /azureApps/azureAppsLayer
      privilege: [ read, execute ]

- !delete
  record: !group secrets/consumers
</pre>

The `!delete` tag removes the `secrets/consumers` group, breaking the relationship between the `azure-apps` group and the variables. We have to load this policy with the following `policy load` command to delete the group resource:

```
docker-compose exec client conjur policy load --delete root myVariablePolicy.yml
```{{execute}}

With this structure in place, the group managing the host policy can add a newly-created host, and withhold variable access until the host resource is added to the layer policy. The group managing the variables policy can create a new variable when needed, knowing which services and hosts have access to it without searching all the host policies.

As we pointed out earlier, policies are stored in a policy tree within Conjur. Different versions of the layer policy can exist within a hierarchy across different branches. This means the host policy and  variables policy can exist at the root level, but the layer policy in each branch assigns appropriate access for that environment. This is discussed in detail in “[Understanding Conjur Policy](https://www.conjur.org/blog/understanding-conjur-policy/)”
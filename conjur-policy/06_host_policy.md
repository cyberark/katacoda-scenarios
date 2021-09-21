The following policy, specific to Azure, defines a “hosts” group containing two host resources. Each host represents an Azure serverless function. We’ve assigned a system-assigned identity to one function and a user-managed identity to the other to show how both operate.

```
- !policy
  id: azure-apps
  body:
    - !group

    - &hosts
      - !host
        id: ConjurDemoAccessFunctionSystemAssigned
        annotations:
          authn-azure/subscription-id: f89ce…..e91dc18
          authn-azure/resource-group: Conjur_Resources
          authn-azure/system-assigned-identity: 7098...0761e13861

      - !host
        id: ConjurDemoAccessFunctionUserAssigned
        annotations:
          authn-azure/subscription-id: f89ced...e91dc18
          authn-azure/resource-group: Conjur_Resources
          authn-azure/user-assigned-identity: ConjurDemoAccess

    - !grant
      role: !group
      members: *hosts

- !grant
  role: !group conjur/authn-azure/AzureWS1/apps
  member: !group azure-apps
```

Let's explore this from the top of the policy file:

<pre class="file" data-filename="myHostPolicy.yml" data-target="replace">- !policy
  id: azure-apps
  body:
    - !group
</pre>

The `!group` tag in the policy creates a group with the same name as the policy: `azure-apps`.

<pre class="file" data-filename="myHostPolicy.yml" data-target="append">    - &hosts
      - !host
        id: ConjurDemoAccessFunctionSystemAssigned
        annotations:
          authn-azure/subscription-id: f89ce…..e91dc18
          authn-azure/resource-group: Conjur_Resources
          authn-azure/system-assigned-identity: 7098...0761e13861

      - !host
        id: ConjurDemoAccessFunctionUserAssigned
        annotations:
          authn-azure/subscription-id: f89ced...e91dc18
          authn-azure/resource-group: Conjur_Resources
          authn-azure/user-assigned-identity: ConjurDemoAccess
</pre>

The “hosts” collection starts with the `&hosts` tag and each host declaration starts with the `!host` tag. The tags under the `annotation` tag in each `!host` tag contain data that Azure sends in the JSON web token (JWT). These annotations are specific to the Azure authenticator.

<pre class="file" data-filename="myHostPolicy.yml" data-target="append">    - !grant
      role: !group
      members: *hosts
</pre>

The first `!grant` tag is part of the policy `body`, so the resources it creates will also be part of the policy. It declares that the members of the `&hosts` collection are also members of the `azure-apps` group (the `*hosts` tag means “all hosts”). You do not have to provide the group name in the `role` tag because the name of the policy is the default name for any resource created within a policy.

<pre class="file" data-filename="myHostPolicy.yml" data-target="append">- !grant
  role: !group conjur/authn-azure/AzureWS1/apps
  member: !group azure-apps
</pre>

The second `!grant` tag is outside the policy. Note that this tag is not indented. It states that members of the `azure-apps` group are also members of the `conjur/authn-azure/AzureWS1/apps` group, which we created in the webservice policy in the previous step. This is important because it tells Conjur which webservice to use to authenticate these hosts. Also, the `azure-apps` name is required in the `member` tag because the `!grant` is outside the policy.

Let's load this policy using the following command:

```
docker cp /root/policy/myHostPolicy.yml root_client_1:/root
docker-compose exec client conjur policy load root /root/myHostPolicy.yml
```{{execute}}

If it loaded successfully, you should receive the following response:

```
Loaded policy 'root'
{
  "created_roles": {
    "quick-start:host:azure-apps/ConjurDemoAccessFunctionSystemAssigned": {
      "id": "quick-start:host:azure-apps/ConjurDemoAccessFunctionSystemAssigned",
      "api_key": "3yrazk12pesw9erf8shq3bd7g1m13gggk6vbyepx3gktx8p2ny1n3v"
    },
    "quick-start:host:azure-apps/ConjurDemoAccessFunctionUserAssigned": {
      "id": "quick-start:host:azure-apps/ConjurDemoAccessFunctionUserAssigned",
      "api_key": "2vh2vyd3cdwqsmfr307z3bdq45b29vs7x1dhv1s2t1fbmy1j9zy30"
    }
  },
  "version": 3
}
```

Since this tutorial is utilizing the authn-azure webservice, the API Keys are not relevant and can be ignored.
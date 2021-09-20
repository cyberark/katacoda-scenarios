The following webservice policy creates a resource that makes the Azure authenticator available to the host policy.

```yaml
- !policy
  id: conjur/authn-azure/AzureWS1
  body:
  - !webservice
 
  - !variable
    id: provider-uri
 
  - !group
    id: apps
    annotations:
      description: Define hosts that authenticate with this authenticator
 
  - !permit
    role: !group apps
    privilege: [ read, authenticate, update ]
    resource: !webservice
```

<pre class="file" data-filename="myWebservicePolicy.yml" data-target="replace">- !policy
  id: conjur/authn-azure/AzureWS1
  body:
</pre>

The `!policy` tag identifies the beginning of a new policy resource.

The `id` tag below the `!policy` tag does two things: it tells Conjur to store the policy in the `conjur/authn-azure` policy branch and it assigns the name `AzureWS1` to the policy.

Since the branch name does not start with a slash, you can store this policy within a branch such as a “dev” branch. If the branch started with a slash, such as “/conjur”, then the policy would be rooted and it would always be stored at the root level.

Various tags define the policy as follows:

* The `!webservice` tag defines that this is a webservice resource.
<pre class="file" data-filename="myWebservicePolicy.yml" data-target="append">  - !webservice

</pre>
* The `!variable` tag is a variable, named `provider-uri`, that is created to contain the URL Conjur uses to access the authentication resource.
<pre class="file" data-filename="myWebservicePolicy.yml" data-target="append">  - !variable
    id: provider-uri

</pre>
* The `!group` tag defines the `apps` group and associates it with this policy.
<pre class="file" data-filename="myWebservicePolicy.yml" data-target="append">  - !group
    id: apps
    annotations:
      description: Define hosts that authenticate with this authenticator
</pre>
* The `!permit` tag grants members of the `apps` group `read, authenticate, update` permissions on this webservice resource.
<pre class="file" data-filename="myWebservicePolicy.yml" data-target="append">  - !permit
    role: !group apps
    privilege: [ read, authenticate, update ]
    resource: !webservice
</pre>

The policy does not store data in the `provider-uri` variable. It just creates a variable to hold this data. This allows us to fill in the data later and change the data without changing the policy.

The `annotations` tag in the `!group` definition holds documentation about the purpose of the group. While you can omit this, it is good practice to provide this information so others understand the group’s purpose.

Let's load this policy using the following command:

```
docker cp /root/policy/myWebservicePolicy.yml root_client_1:/root/policy
docker-compose exec client conjur load policy root /root/policy/myWebservicePolicy.yml
```{{execute}}

If it loaded successfully, you should receive the following response:
[RESERVED FOR RESPONSE]
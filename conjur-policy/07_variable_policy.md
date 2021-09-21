The last policy of this example, below, allows each “host” to be authenticated using the “webservice” to read data from two variables.

```
- !policy
  id: secrets
  body:
    - !group consumers

    - !variable endpoint
    - !variable authKey

    - !permit
      role: !group consumers
      privilege: [ read, execute ]
      resource: !variable endpoint

    - !permit
      role: !group consumers
      privilege: [ read, execute ]
      resource: !variable authKey

- !grant
  role: !group secrets/consumers
  member: !group azure-apps
```

Let's explore this from the top of the policy file:

<pre class="file" data-filename="myVariablePolicy.yml" data-target="replace">- !policy
  id: secrets
  body:
    - !group consumers
</pre>

This policy creates a group named `consumers`, 

<pre class="file" data-filename="myVariablePolicy.yml" data-target="append">    - !variable endpoint
    - !variable authKey
</pre>

a variable named `endpoint`, and a variable named `authKey`.

<pre class="file" data-filename="myVariablePolicy.yml" data-target="append">    - !permit
      role: !group consumers
      privilege: [ read, execute ]
      resource: !variable endpoint

    - !permit
      role: !group consumers
      privilege: [ read, execute ]
      resource: !variable authKey
</pre>

The two `!permit` statements in the policy grant `read` and `execute` privileges on the two variables to members of the `consumers` group.

<pre class="file" data-filename="myVariablePolicy.yml" data-target="append">- !grant
  role: !group secrets/consumers
  member: !group azure-apps
</pre>

The last `!grant` statement, outside the policy, adds members of the `azure-apps` group to the `consumers` group created by this policy. This adds the `hosts` collection from the previous step to the `consumers` group so the hosts can access these data items.

As we saw in the webservice policy, the policy doesn’t store data in these variables. It just creates a secure place for the data, which you can add or update using other Conjur commands (see “[Examples – Use the CLI to load and set the variable value](https://docs.conjur.org/Latest/en/Content/Operations/Policy/statement-ref-variable.htm?tocpath=Fundamentals%7CPolicy%20Management%7CPolicy%20Statement%20Reference%7C_____12)”. Conjur keeps the last twenty versions of a secret (that is, the value assigned to a variable) and provides a way to retrieve a specific version of a secret, letting you pre-populate secrets.

Let's load this policy using the following command:

```
cat /root/policy/myVariablePolicy.yml | docker exec -i root_client_1 conjur policy load root -
```{{execute}}

If it loaded successfully, you should receive the following response:

```
Loaded policy 'root'
{
  "created_roles": {
  },
  "version": 4
}
```

With the policy loaded, we have established two separate secret variables that are not initialized. We need to add a secret value to them to initialize and allow them to be executed.  We can use the Conjur CLI to do this.

```
docker exec root_client_1 conjur variable values add secrets/endpoint endpointAddress
```{{execute}}

```
docker exec root_client_1 conjur variable values add secrets/authKey authenticationKeyValue
```{{execute}}
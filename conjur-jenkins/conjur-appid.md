
Next, we need to create an application identity for Conjur

The following steps create Conjur policy that defines the Jenkins host and adds that host to a layer.

1. Declare a policy branch for Jenkins & save it as a .yml file

```
docker-compose exec client bash
cat > conjur.yml << EOF
- !policy
  id: jenkins-frontend
EOF
exit
```{{execute}}

2. You may change the id in the above example if desired
3. Load the policy into Conjur under root: 

`docker-compose exec client conjur policy load --replace root /conjur.yml`{{execute}}

4. Declare the layer and Jenkins host in another file. Copy the following policy as a template & save it.

```
docker-compose exec client bash
cat > jenkins-frontend.yml << EOF
- !layer
- !host frontend-01
- !grant
  role: !layer
  member: !host frontend-01
EOF
exit
```{{execute}}

This policy does the following: 

- Declares a layer that inherits the name of the policy under which it is loaded. In our example, the layer name will become jenkins-frontend.
- Declares a host named frontend-01
- Adds the host into the layer. A layer may have more than one host.
Change the following items:
- Change the host name to match the DNS host name of your Jenkins host. Change it in both the !host statement and the !grant statement.
- Optionally declare additional Jenkins hosts. Add each new host as a member in the !grant statement.

5. Load the policy into Conjur under the Jenkins policy branch you declared previously: 

`docker-compose exec client conjur policy load jenkins-frontend /jenkins-frontend.yml | tee frontend.out`{{execute}}

As it creates each new host, Conjur returns an API key.

We will use the host entity later within this tutorial, so let's put it in memory
```
export frontend_api_key=$(tail -n +2 frontend.out | jq -r '.created_roles."quick-start:host:jenkins-frontend/frontend-01".api_key')
echo $frontend_api_key
```{{execute}}

6. Save the API keys returned in the previous step. You need them later when configuring Jenkins credentials for logging into Conjur.

### Declare variables in Conjur policy

The following steps create Conjur policy that defines each variable and provides appropriate privileges to the Jenkins layer to access those variables.

If variables are already defined, you need only add the Jenkins layer to an existing permit statement associated with the variable. The following steps assume that the required variables are not yet declared in Conjur.

7. Declare a policy branch for the application & save it

```
docker-compose exec client bash
cat > conjur2.yml << EOF
- !policy
  id: jenkins-app
EOF
exit
```{{execute}}

8. You may change the id in the above example.

9. Load the policy into Conjur: 

`docker-compose exec client conjur policy load root /conjur2.yml`{{execute}}

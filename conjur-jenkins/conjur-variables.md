
4. Declare the variables, privileges, and entitlements. Copy the following policy as a template:

```
docker-compose exec client bash
cat > jenkins-app.yml << EOF
#Declare the secrets required by the application

- &variables
  - !variable web_password

# Define a group and assign privileges for fetching the secrets

- !group secrets-users

- !permit
  resource: *variables
  privileges: [ read, execute ]
  roles: !group secrets-users

# Entitlements that add the Jenkins layer of hosts to the group  

- !grant
  role: !group secrets-users
  member: !layer /jenkins-frontend
EOF
exit
```{{execute}}

This policy does the following: 
- Declares the variables to be retrieved by Jenkins.
- Declares the groups that have read & execute privileges on the variables.
- Adds the Jenkins layer to the group. The path name of the layer is relative to root.

Change the variable names, the group name, and the layer name as appropriate.

5. Load the policy into Conjur under the Jenkins policy branch you declared previously: 

`docker-compose exec client conjur policy load jenkins-app /jenkins-app.yml`{{execute}}


### Set variable values in Conjur

Use the Conjur CLI or the UI to set variable values.

The CLI command to set a value is: 

`conjur variable values add <policy-path-of-variable-name> <secret-value>`

For example: 

```
docker-compose exec client conjur variable values add jenkins-app/web_password NotSoSecureSecret
```{{execute}}

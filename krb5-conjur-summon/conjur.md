In this step, we will setup a Conjur OSS container, load some policies and create a machine identity for the host.

### Install Conjur
Let's pull and setup a Conjur OSS.   It will take a couple of moments.
`./setupConjur.sh https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/`{{execute}}

### Prepare Conjur Policy
The sample policies have been prepared for you. 

**Root policy**

Run `cat conjur.yml`{{execute}} to review the root policy
```
- !policy
  id: krb5

- !policy
  id: frontend
```
**krb5 policy**

Run `cat krb5.yml`{{execute}} to review the root policy

```
- &variables
  - !variable keytab
- !group secrets-users
  privileges: [ read, execute ]
  roles: !group secrets-users
- !grant
  role: !group secrets-users
  member: !layer /frontend
```

**frontend policy**

Run `cat frontend.yml`{{execute}} to review the root policy

```
- !layer
- !host frontend-01
- !grant
  role: !layer
  member: !host frontend-01
```
### Load Conjur Policies

Now let's copy the policy files to Conjur CLI container and load them.

**Load Root Policy**

```
docker cp conjur.yml root_client_1:/tmp/
docker-compose exec client conjur policy load --replace root /tmp/conjur.yml
```{{execute}}

**Load Frontend Policy**
```
docker cp frontend.yml root_client_1:/tmp/
docker-compose exec client conjur policy load frontend /tmp/frontend.yml | tee frontend.out
```{{execute}}

**Load Krb5 Policy**
```
docker cp krb5.yml root_client_1:/tmp/
docker-compose exec client conjur policy load krb5 /tmp/krb5.yml
```{{execute}}

### Add Keytab as variables
Copy the `user.keytab` file to Conjur CLI container and add to Conjur as a variable.

```
docker cp user.keytab root_client_1:/tmp/
docker-compose exec client bash -c "head -c1024 /tmp/user.keytab | conjur variable values add krb5/keytab" 
```{{execute}}

### Cleanup 
It's time to remove the keytab files.

```
rm user.keytab
docker-compose exec client bash -c "rm /tmp/user.keytab"
```{{execute}}

To verify:
`ls user.keytab`{{execute}}

`docker-compose exec client bash -c "ls /tmp/*.keytab"`{{execute}}

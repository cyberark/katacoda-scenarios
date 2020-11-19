The sample policies have been prepared for you. 

**Root policy**

Run `cat conjur.yml`{{execute}} to review the root policy
```
- !policy
  id: server

- !policy
  id: ansible
```
**Server policy**

Run `cat server.yml`{{execute}} to review the root policy

```
- &variables
  - !variable host1/host
  - !variable host1/user
  - !variable host1/pass
  - !variable host2/host
  - !variable host2/user
  - !variable host2/pass

- !group secrets-users

- !permit
  resource: *variables
  privileges: [ read, execute ]
  roles: !group secrets-users

# Entitlements 
- !grant
  role: !group secrets-users
  member: !layer /ansible

```

**ansible policy**

Run `cat ansible.yml`{{execute}} to review the root policy

```
- !layer
- !host ansible-01
- !grant
  role: !layer
  member: !host ansible-01
```
### Load Conjur Policies

Now let's copy the policy files to Conjur CLI container and load them

**Load Root Policy**

```
docker cp conjur.yml conjur_client_1:/tmp/
docker-compose exec client conjur policy load --replace root /tmp/conjur.yml
```{{execute}}

**Load ansible Policy**
```
docker cp ansible.yml conjur_client_1:/tmp/
docker-compose exec client conjur policy load ansible /tmp/ansible.yml  | tee ansible.out
```{{execute}}

**Load server Policy**
```
docker cp server.yml conjur_client_1:/tmp/
docker-compose exec client conjur policy load server /tmp/server.yml
```{{execute}}

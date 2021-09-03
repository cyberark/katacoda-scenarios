
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

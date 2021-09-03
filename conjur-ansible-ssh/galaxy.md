
We will now grant an application ID to the Ansible server.

1. Install the Conjur role using the following syntax:
```
ansible-galaxy install cyberark.conjur-host-identity
```{{execute}}

2.  Get the SSL Cert from Conjur CLI
```
docker cp conjur_client_1:/root/conjur-demo.pem /root/
```{{execute}}

3. Create a host factory token
```
docker-compose exec client conjur hostfactory token create ansible|tee hftoken
```{{execute}}

4. Save the token as environment 
```
export HFTOKEN="$(grep token hftoken | cut -d: -f2 | tr -d ' \r\n' | tr -d ','  | tr -d '\"' )"
```{{execute}}

5. Prepare an inventory file: `cat inventory`{{execute}}

6. Prepare a playbok to grant the ansible host with Conjur Identity: `cat grant_conjur_id.yml`{{execute}}

7. Grant it!  `ansible-playbook -i inventory grant_conjur_id.yml`{{execute}}

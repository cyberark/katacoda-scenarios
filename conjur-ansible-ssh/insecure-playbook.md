

Here comes a typical ansible playbook & inventory

### Inventory file 

First, we will need to create an inventory file about our servers

```
cat <<EOF > insecure-playbook/inventory
[demo_servers]
host01 ansible_connection=ssh ansible_host=[[HOST_IP]] ansible_ssh_user=service01 ansible_ssh_pass=W/4m=cS6QSZSc*nd
host02 ansible_connection=ssh ansible_host=[[HOST2_IP]] ansible_ssh_user=service02 ansible_ssh_pass=5;LF+J4Rfqds:DZ8
EOF 
```{{execute HOST1}}

### Let's try the sample playbook

`ansible-playbook -i insecure-playbook/inventory insecure-playbook/insecure-playbook.yml`{{execute HOST1}}

In this tutorial, we will show you how to secure Ansible using Conjur to protect SSH secrets

We will need to manage two servers via SSH by Ansible.
Typically that'll involve:
1. Create SSH service accounts on the managed servers
2. Install Ansible
3. Prepare an inventory file to specify the connection details of the managed servers
4. Prepare a playbook to specifiy the tasks

Let's get started!

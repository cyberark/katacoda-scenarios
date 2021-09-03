Ansible is an agentless configuration management tool for provisioning, configuring, and deploying applications. Ansible is great for configuration management, but it’s not designed to manage secrets across multiple tools and cloud environments.

With this fully interactive hosted tutorial you will learn how to secure Ansible automation by keeping unsecured secrets out of Playbooks with Conjur open source secrets management.

# How it works?
<table><tr><td>
<img src="https://raw.githubusercontent.com/quincycheng/katacoda-scenarios/master/conjur-ansible-ssh/media/ansible.svg" width="600px"/>
    </td><td>
1. Install Ansible Conjur Role and Lookup Plug-in
2. Load a Conjur policy that grants the Ansible control machine privileges on secrets
3. Run a playbook containing references to secrets stored in Conjur
4. Authenticate the control machine to Conjur
5. Issue the secrets
6. Playbook fetches secrets from Conjur and executes
    
</td></tr></table>
All you need is a web browser and a few minutes to get started; no need to install anything!
Let's get started!

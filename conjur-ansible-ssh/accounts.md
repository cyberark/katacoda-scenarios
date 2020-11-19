
Ansible can manage servers via SSH.
First we need to create SSH accounts on our managed servers

## Local Server

Let's create an account on host 1
```
useradd -m -d /tmp service01
passwd service01
```{{execute HOST1}}

Enter new UNIX password: `W/4m=cS6QSZSc*nd`{{execute HOST1}}

Retype new UNIX password: `W/4m=cS6QSZSc*nd`{{execute HOST1}}

## Remote Server

Let's create a service account on host 2

```
useradd -m -d /tmp service02
passwd service02
```{{execute HOST2}}

Enter new UNIX password: `5;LF+J4Rfqds:DZ8`{{execute HOST2}}

Retype new UNIX password: `5;LF+J4Rfqds:DZ8`{{execute HOST2}}

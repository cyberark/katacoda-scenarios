We will make use of the host as the client and create a container as Kerberos KDC.

### Install Kerberos Client
First, we install Kerberos client on the host

```
apt-get update
apt-get install -y krb5-user
```{{execute}}

Default Kerberos version 5 realm: `CYBERARKDEMO.COM`{{execute}}

Kerberos servers for your realm: `localhost`{{execute}}

Administrative server for your Kerberos realm: `localhost`{{execute}} 

 
### Setup Kerberos Server
Let's setup a Kerberos server on docker
```
chmod +x *.sh
docker-compose -f docker-compose-krb5.yml up -d 
```{{execute}}


### Verify Setup

Let's try to logon as `admin/admin@CYBERARKDEMO.COM`

`kinit admin/admin@CYBERARKDEMO.COM`{{execute}}

Password for admin/admin@CYBERARKDEMO.COM:`5b1d328bc88b97356f406fab456b5a99`{{execute}}

To verify the logged on principal, we can execute  `klist`{{execute}}

```
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: admin/admin@CYBERARKDEMO.COM

Valid starting       Expires              Service principal
2018-12-14 14:10:16  2018-12-15 02:10:16  krbtgt/CYBERARKDEMO.COM@CYBERARKDEMO.COM
        renew until 2018-12-21 14:10:05
```

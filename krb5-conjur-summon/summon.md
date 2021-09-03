### Install Summon
Installing Summon is simple.  Simply download 2 files and summon is ready to go.

```
curl -OL https://github.com/cyberark/summon/releases/download/v0.6.9/summon-linux-amd64.tar.gz
tar zvxf summon-linux-amd64.tar.gz
cp -f summon /usr/local/bin/

curl -OL https://github.com/cyberark/summon-conjur/releases/download/v0.5.2/summon-conjur-linux-amd64.tar.gz
tar zvxf summon-conjur-linux-amd64.tar.gz 
mkdir /usr/local/lib/summon/
cp -f summon-conjur /usr/local/lib/summon/
```{{execute}}

### Configure Summon
Let's configure summon by using environmental variables.
For more details, please refer to [Conjur provider for Summon.](https://github.com/cyberark/summon-conjur)
```
export CONJUR_MAJOR_VERSION=5
export CONJUR_ACCOUNT=demo
export CONJUR_APPLIANCE_URL=https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com
export CONJUR_AUTHN_LOGIN=host/frontend/frontend-01
export CONJUR_AUTHN_API_KEY=$(tail -n +2 frontend.out | jq -r '.created_roles."demo:host:frontend/frontend-01".api_key')
```{{execute}}

We will make sure of `secrets.yml` file for injecting the keytab file.
To review it, run `cat secrets.yml`{{execute}}
```
KEYTAB: !var:file krb5/keytab
```

### Summon Keytab
First, we destroy the user’s active Kerberos authorization tickets.

`kdestroy`{{execute}}

And we can verify it by running:

`klist`{{execute}}

To summon keytab, we can get the path to memeory-mapped keytab files using the environment variable `KEYTAB`, which is defined in `secrets.yml`

`summon bash -c 'kinit quincy@CYBERARKDEMO.COM -k -t $KEYTAB'`{{execute}}

We can now successfully logon, and this time `klist` works:

`klist`{{execute}}

```
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: quincy@CYBERARKDEMO.COM

Valid starting       Expires              Service principal
2018-12-14 15:12:55  2018-12-15 03:12:55  krbtgt/CYBERARKDEMO.COM@CYBERARKDEMO.COM
        renew until 2018-12-15 15:12:55
```

This way the keytab is not stored in any environment except Conjur.  To verify it, we can review the `KEYTAB` variable

`echo $KEYTAB`{{execute}}

It should be empty, that means it cannot be extracted from the environment and it is very secure.

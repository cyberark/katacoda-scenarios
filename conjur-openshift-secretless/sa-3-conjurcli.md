

In this section, we'll configure the following items for setting up the Conjur client:

1. Alias for CLI
2. Reset Admin password
3. Logging in


## Alias for Conjur CLI

Conjur CLI client can be either installed as [Ruby gem](https://docs.conjur.org/Latest/en/Content/Tools/CLI_Install_CLI.htm?tocpath=Setup%7C_____2#ruby-gem) or [Docker Container](https://docs.conjur.org/Latest/en/Content/Tools/CLI_Install_CLI.htm?tocpath=Setup%7C_____2#docker-container).
In this tutorial, we will install the binary version

```
wget https://github.com/cyberark/conjur-api-python3/releases/download/v7.0.1/conjur-cli-rhel-7.tar.gz
tar xvf conjur-cli-rhel-7.tar.gz
cp conjur /usr/local/bin
```{{execute}}

In your own environment, you may wish to add it in shell script file, e.g. `~/.bashrc` or `~/.zshrc`

## Initalize Conjur CLI

To initialize the client, execute:
`conjur --insecure init --url https://$CONJUR_URL --account default`{{execute}}

Trust this certificate: `yes`{{execute}}

```
Wrote certificate to /root/conjur-default.pem
Wrote configuration to /root/.conjurrc
```

## Login 

Now, we will need to logon to Conjur CLI.
Remember the admin API key?  Don't worry, we can get it by executing `grep admin admin.out`{{execute}}

```
conjur --insecure login -i admin -p $(grep admin admin.out | cut -c20-)
```{{execute}}

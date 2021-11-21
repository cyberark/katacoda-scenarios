

In this section, we'll configure the following items for setting up the Conjur client:

1. Alias for CLI
2. Reset Admin password
3. Logging in


## Alias for Conjur CLI

Conjur CLI client can be either installed as [Ruby gem](https://docs.conjur.org/Latest/en/Content/Tools/CLI_Install_CLI.htm?tocpath=Setup%7C_____2#ruby-gem) or [Docker Container](https://docs.conjur.org/Latest/en/Content/Tools/CLI_Install_CLI.htm?tocpath=Setup%7C_____2#docker-container).
In this tutorial, we will install the binary version

```
mkdir conjur-cli && cd conjur-cli
wget https://github.com/cyberark/conjur-api-python3/releases/download/v7.0.1/conjur-cli-rhel-7.tar.gz
tar xvf conjur-cli-rhel-7.tar.gz
cp conjur /usr/local/bin
cd ..
rm -rf conjur-cli
```{{execute}}

In your own environment, you may wish to add it in shell script file, e.g. `~/.bashrc` or `~/.zshrc`

## Initalize Conjur CLI

Certificate of conjur is required for Conjur CLI client.
To retrieve, execute:

```
openssl s_client -showcerts -connect $CONJUR_URL:443 < /dev/null 2> /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > conjur.pem
```{{execute}}


To initialize the client, execute:
`conjur init --force --url https://$CONJUR_URL --account default -c conjur.pem`{{execute}}


```
Wrote certificate to /root/conjur-default.pem
Wrote configuration to /root/.conjurrc
```

## Login 

Now, we will need to logon to Conjur CLI.
Remember the admin API key?  Don't worry, we can get it by executing `grep admin admin.out`{{execute}}

```
conjur login -i admin -p $(grep admin admin.out | cut -c20-)
```{{execute}}

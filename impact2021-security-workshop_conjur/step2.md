To run the Conjur server, database and client:

`docker-compose up -d`{{execute}}

To create a default account (eg. quick-start):

```
docker-compose exec conjur conjurctl account create quick-start | tee admin.out
```{{execute}}

> Prevent data loss:
> The conjurctl account create command gives you the public key and admin API key for the account you created. Back them up in a safe location.

> Please copy the API key for admin for logging in to the system

Initialize the Conjur client using the account name and admin API key you created:

`docker-compose exec client bash -c "echo yes | conjur init -u http://conjur -a quick-start"`{{execute}}

```
export api_key=$(grep API admin.out | cut -d: -f2 | tr -d ' \r\n')
docker-compose exec client conjur authn login -u admin -p $api_key
```{{execute}}

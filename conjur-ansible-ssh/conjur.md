
Conjur has been spinned up for you.
Let's make sure it is up and running by accessing the web interface
Please wait for a moment if it doesn't display "Your Conjur server is running!"

To access the web interface:
https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/

To create an account in Conjur, execute:
```
cd conjur
docker-compose exec conjur conjurctl account create demo | tee admin.out
```{{execute}}

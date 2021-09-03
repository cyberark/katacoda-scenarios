
We intiated Conjur for you, now let's verify that it is complete by checking the web interface.

Note:
Please wait for a moment if it doesn't display "Your Conjur server is running!"

To access the web interface:
https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/

To create an account in Conjur, execute:
```
cd conjur
docker-compose exec conjur conjurctl account create demo | tee admin.out
```{{execute}}

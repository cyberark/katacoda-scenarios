The environment we'll be working in has Docker running with containers pre-deployed.

To view the containers running, execute the following command:
```
docker ps
```{{execute}}

The containers returned should be:
* cyberark/conjur
* conjurinc/cli5
* postgres:10.16

Let's break down each container's purpose for this scenario.

# cyberark/conjur
This container is the CyberArk Conjur appliance. It has been pre-configured for this scenario. As you have already experienced from the last executed command, it is online and available for serving requests.

# conjurinc/cli5
The container running this image has a pre-configured Conjur CLI. We will be `docker exec`'ing into it to use the Conjur CLI for administrative tasks against the cyberark/conjur container.

To ensure the CLI was pre-configured properly, let's execute a `list` command to see all the resources we have access to inside Conjur.

```
docker exec root_client_1 conjur list
```{{execute}}

If everything is authenticated properly, you should have received the following response:

```
[
  "quick-start:policy:root",
  "quick-start:user:demouser",
  "quick-start:policy:devapp",
  "quick-start:group:devapp/secret-users",
  "quick-start:variable:devapp/db_uname",
  "quick-start:variable:devapp/db_pass"
]
```

# postgres
This container is the database that stores Conjur data in an encrypted state. A master data key is generated that is used to encrypt all entries within the database. Only Conjur, having this master data key, can decrypt the data within.  In the Enterprise version of Conjur, Postgres lives inside the appliance container next to the Conjur service.
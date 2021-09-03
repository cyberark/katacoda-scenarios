
The environment we'll be working in has Docker running with containers pre-deployed.

To view the containers running, execute the following command:
```
docker ps
```{{execute}}

The containers returned should be:
* conjurinc/cli5
* cyberark/conjur
* mattrayner/lamp
* postgres

Let's break down each container's purpose for this scenario.

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

The last two secrets are what we'll be working with today to connect our web application to MySQL.

To view the value of `db_uname`, execute the following command: `docker exec root_client_1 conjur variable value devapp/db_uname`{{execute}}

To view the value of `db_pass`, execute the following command: `docker exec root_client_1 conjur variable value devapp/db_pass`{{execute}}

# cyberark/conjur
This container is the CyberArk Conjur appliance. It has been pre-configured for this scenario. As you have already experienced from the last executed command, it is online and available for serving requests.

# postgres
This container is the database that stores Conjur data in an encrypted state. A master data key is generated that is used to encrypt all entries within the database. Only Conjur, having this master data key, can decrypt the data within.  In the Enterprise version of Conjur, Postgres lives inside the appliance container next to the Conjur service.

# lamp
This container is a full LAMP stack. LAMP stands for Linux, Apache, MySQL and PHP. This stack has been pre-configured and is waiting on us to provide a web application in the local `/opt/app` directory.

Let's create a quick index page and add a simple message to it:

<pre class="file" data-filename="index.php" data-target="replace">Hello, World!</pre>

To view the current website, click the `Web App` tab next to `Terminal`, or click [https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/](https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/)
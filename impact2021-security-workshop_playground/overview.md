
The environment we'll be working in has Docker running with containers pre-deployed.

To view the containers running, execute the following command:
```
docker ps
```{{execute}}

The containers returned should be:
* conjurinc/cli5
* mattrayner/lamp
* cyberark/conjur
* postgres

_NOTE: cyberark/conjur and postgres are combined into the same appliance container for Conjur Enterprise._

Let's break down each container's purpose for this scenario.

# conjurinc/cli5
The CyberArk CLI for Conjur is installed within the container named `root_client_1`.  It has been pre-configured to connect to the Conjur service available in the container named `root_conjur_1`.  We will be using this to interact with the Conjur service in this scenario.

To check who you are logged in as, execute the following command: `docker exec root_client_1 conjur authn whoami`{{execute}}

Next, let's see what resources in Conjur our user has access to. To do this, execute the following command:
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

# cyberark/conjur
This container is the CyberArk Conjur service. It has been pre-configured for this scenario. As you have already experienced from the last executed command, it is online and available for serving requests.

# postgres
This container is the PostgreSQL database backend that stores the secrets used by the CyberArk Conjur service encrypted.

# mattrayner/lamp
This container is a full LAMP stack. LAMP stands for Linux, Apache, MySQL and PHP. This stack has been pre-configured and is waiting on us to provide a web application in the local `/opt/app` directory.

Let's create a quick index page and add a simple message to it:

<pre class="file" data-filename="index.php" data-target="replace">Hello, World!</pre>

To view the current website, click the `Web App` tab next to `Terminal`.

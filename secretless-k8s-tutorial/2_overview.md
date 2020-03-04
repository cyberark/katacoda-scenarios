Applications and application developers should be incapable of leaking secrets.

To achieve that goal, you’ll play two roles in this tutorial:

1. A Security Admin who handles secrets, and has sole access to those secrets
2. An Application Developer with no access to secrets.

The situation looks like this:

<p align="center">
  <img src="https://secretless.io/img/secretless_overview.jpg">
</p>

Specifically, we will:

**As the security admin:**

1. Create a PostgreSQL database
2. Create a DB user for the application
3. Add that user’s credentials to Kubernetes Secrets
4. Configure Secretless to connect to PostgreSQL using those credentials

**As the application developer:**

1. Configure the application to connect to PostgreSQL via Secretless
2. Deploy the application and the Secretless sidecar

# Up next...
Play the role of a Security Admin and learn how to set up PostgreSQL and configure Secretless.


Most API calls require an authentication access token in the header. Here’s how to obtain it if you’re a human user:

Use a username and password to obtain an API key (refresh token) with the Authentication > Login method.

Use the API key to obtain an access token with the Authentication > Authenticate method.

If you’re a machine, your API key will be provided by your operator.   This will be covered in later steps.

Access tokens expire after 8 minutes. You need to obtain a new token after it expires. Token expiration and renewal is handled automatically by the Conjur client libraries.


### Login

Gets the API key of a user given the username and password via HTTP Basic Authentication.

Passwords are stored in the Conjur database using bcrypt with a work factor of 12. Therefore, login is a fairly expensive operation. However, once the API key is obtained, it may be used to inexpensively obtain access tokens by calling the Authenticate method. An access token is required to use most other parts of the Conjur API.

Your HTTP/REST client probably provides HTTP basic authentication support. For example, curl and all of the Conjur client libraries provide this.

Note that machine roles (Hosts) do not have passwords and do not need to login.

`export refresh_token=$(curl -s --user admin:$conjur_admin https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/authn/demo/login) && echo $refresh_token`{{execute}}


### Authenticate

Gets a short-lived access token, which can be used to authenticate requests to (most of) the rest of the Conjur API. A client can obtain an access token by presenting a valid login name and API key.

The login must be URL encoded. For example, alice@devops must be encoded as alice%40devops.

```
export response=$(curl -s -X POST https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/authn/demo/admin/authenticate -d ${refresh_token})
export access_token=$(echo -n $response | base64 | tr -d '\r\n') && echo $access_token
```{{execute}}

### Refresh the token

In this tutorial, a script is prepared for displaying the details and refreshing the `refresh token`

To execute, `source showSettings.sh`{{execute}}


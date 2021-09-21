We use the following resources to develop policies for serverless functions:

* `Webservices` to associate a name with data needed to use the service
* `Hosts` to associate a name with data needed to identify the host
* `Layers` to model the “many-to-many” relationships between hosts and variables
* `Groups` to define collections of hosts

Policies define relationships using two statement types: `grant` statements that determine which roles have access to resources and `permit` statements that assign rights to roles.

Before a function can obtain a secret, it sends its identifying data to Conjur. Conjur looks for a host resource that has the same identifying data. If Conjur finds a resource, it uses the groups associated with the host to find a webservice to authenticate the function’s identifying data. Once Conjur verifies the host’s identity, Conjur returns a token to the function. The function then requests to read a variable with this token attached. In the groups associated with the host, Conjur finds the layer resource that provides access to the variables the function is requesting to read.

Azure uses system-assigned identities and user-managed identities to provide the identifying data mentioned above. While system-assigned identities are associated with a single function, user-managed identities can be assigned to many functions. A Conjur policy provides the same rights to all functions with the same identity, so you can grant the same rights to many functions by assigning them the same user-managed identity. Also, you can define a Conjur host resource as soon as you create the user-managed identity, so you can proactively create Conjur policies to provide access rights while deployment is in progress.

Conjur stores policies in a tree structure, starting with a “root” level, then branching into policies. Organizing policies this way allows “leaf” policies to inherit properties from other policies closer to the root.

Administrators write policies in text files using the [YAML policy language syntax](https://docs.conjur.org/Latest/en/Content/Operations/Policy/policy-syntax.htm?tocpath=Fundamentals%7CPolicy%20Management%7C_____3). Load policy files into Conjur using the [“policy load” command](https://docs.conjur.org/Latest/en/Content/Operations/Policy/policy-load.html?tocpath=Fundamentals%7CPolicy%20Management%7C_____2). You can execute the command from the Conjur command-line interface (CLI) or by functions in the application programming interface (API).
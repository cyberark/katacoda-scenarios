
This scenario is an interactive walkthrough of the Conjur Blog post titled "Secrets Management RBAC Policy Example" and can be found on the [Conjur Blog](https://www.conjur.org/blog/secrets-management-rbac-policy-example/).

# About
Conjur controls access to secrets using role-based access control (RBAC). We cover this in detail in Policy Concepts, but, to summarize, Conjur uses policies to define “permissions”, “resources”, and “roles”, and to establish relationships between them.

Associating group resources with “roles” defines relationships that determine who accesses resources and what operations they can perform. For example, a role can allow one group to read a variable while allowing a different group to update that variable. Conjur policies are built using several types of resources, but this article will focus on the webservice, host, layer, and group resources.

While this article uses Azure serverless functions in the example, the same basic policy concepts apply to other platforms and applications.
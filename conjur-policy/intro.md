
This scenario is an interactive walkthrough of the Conjur Blog post titled "Secrets Management RBAC Policy Example" and can be found on the [Conjur Blog](https://www.conjur.org/blog/secrets-management-rbac-policy-example/).

# About
Conjur controls access to secrets using [role-based access control (RBAC)](https://www.conjur.org/solutions/rbac/). We cover this in detail in [Policy Concepts](https://docs.conjur.org/Latest/en/Content/Operations/Policy/policy-basic-concepts.htm?tocpath=Fundamentals%7CPolicy%20Management%7CSecurity%20policy%20as%20code%7C_____1), but, to summarize, Conjur uses policies to define “permissions”, “resources”, and “roles”, and to establish relationships between them.

Associating group resources with “roles” defines relationships that determine who accesses resources and what operations they can perform. For example, a role can allow one group to read a variable while allowing a different group to update that variable. Conjur policies are built using several types of resources, but this article will focus on the webservice, host, layer, and group resources.

While this article uses Azure serverless functions in the example, the same basic policy concepts apply to other platforms and applications.
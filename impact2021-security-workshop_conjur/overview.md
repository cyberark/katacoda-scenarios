This tutorial will guide you on how to install your own Conjur Open Source on a Docker host, and enroll an application to Conjur.

Conjur is an open source security service that integrates with popular tools to provide data encryption, identity management for humans and machines, and role-based access control for sensitive secrets like passwords, SSH keys, and web services.

A very common question is: how do I add new secrets and apps to my infrastructure?

At Conjur, we refer to this process of adding new stuff as “enrollment”. The basic flow works in four steps:

1. Define protected resources, such as Webservices and Variables, using a policy. Call this “Policy A”.
2. In “Policy A”, create a group which has access to the protected resources.
3. Define an application, generally consisting of a Layer (group of hosts), in another policy. Call this “Policy B”.
4. In “Policy A”, add the Layer from “Policy B” to a group which has access to the protected resources.
Step (4) has a special name, “entitlement”, because in this step existing objects are linked together, and no new objects are created. An entitlement is always one of the following:

- Grant a policy Group to a Layer.
- Grant a policy Group to a different Group (usually a group of Users).
Organizing policy management into three categories - protected resources, applications, and entitlements - helps to keep the workflow organized and clear. It also satisfies the essential security requirements of separation of duties and least privilege.

- **Separation of duties** Management of protected resources is separated from management of client applications. Different teams can be responsible for each of these tasks. In addition, policy management can also be delegated to machine roles if desired.
- **Least privilege** The client applications are granted exactly the privileges that they need to perform their work. And policy managers (whether humans or machines) have management privileges only on the objects that rightfully belong under their control.
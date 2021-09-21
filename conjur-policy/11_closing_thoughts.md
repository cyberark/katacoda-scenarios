Conjur’s security-policy-as-code system provides the tools you need to express complex security relationships in code that can be safely checked into code repositories. The hierarchical policy structure enables you to build a set of common resources like authenticator webservices, hosts, and variables for use in all environments. The branch structure enables you to implement multiple specific layer resources that tailor access, in turn, to common resources, meeting requirements of specific environments.

Let’s review the key points illustrated in this article for defining policies for serverless functions:

* You need to define a webservice resource for each authenticator.
* Policies defining authenticator webservice resources are usually root-level policies unless the data associated with them changes for different environments.
* Host resources model functions.
* Host resources are associated with authenticators.
* Variables are defined in their own policies.
* Layer policies allow hosts to access variables.

Using user-managed identities, this policy structure creates and maintains entire permissions hierarchies separately from any application or service implementation. This is possible because the identity can be encoded in the policy before the infrastructure is created. You can grant or recall rights by changing the policies, and you can change policies without affecting any functions or machines.

My serverless example differs from CyberArk’s best practices, which recommend using host policies to model physical infrastructure and layer policies to model applications and functions. That practice assumes the host is a physical machine authenticating to Conjur. However, when a serverless function is authenticating to Conjur like a host would, it makes sense to model the serverless function as a host rather than a layer.

Conjur is platform independent, so applications running on any platform, such as [Amazon Web Services (AWS)](https://www.conjur.org/blog/aws-iam-authenticator-tutorial-for-conjur-open-source/) and Azure, can use the same secrets. Although the authenticators for each platform are different, everything else in the Conjur hierarchy remains the same.

These examples are just the starting point for investigating Conjur policies. In this article, you will find many links to Conjur documentation to help you investigate these topics further. You can also investigate the [policy tutorials](https://www.conjur.org/get-started/tutorials/) to learn more.
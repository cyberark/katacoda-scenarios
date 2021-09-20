Now that we have covered the concepts, let’s create a set of policies that will allow an Azure function to read a variable. For this example, we will grant access with just a webservice, host, and variable policy.

The version of the “policy load” command we use in this example has this form:

```shell
conjur policy load root policy-file-name.yml
```

To implement this example, save each policy described below in a separate text file, then execute the “policy load” command from the Conjur client to load each policy. For example, if the policies are in “myWebservicePolicy.yml”, “myHostPolicy.yml”, and “myVariablePolicy.yml” in the current working directory, you execute these commands from the Conjur client:

```shell
conjur policy load root myWebservicePolicy.yml
conjur policy load root myHostPolicy.yml
conjur policy load root myVariablePolicy.yml
```
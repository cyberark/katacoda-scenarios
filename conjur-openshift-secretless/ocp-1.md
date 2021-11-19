The OpenShift environment has been prepared for you.

It will take a minute or two.

If it shows `OpenShift Ready`, that means we're ready to proceed! &#128513;	

## Tips

Before you get started,  we recommend reading the following tips. They explain how you can access the openshift environment.

## Logging in to the Cluster via Dashboard

Click the [Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com) tab to open the dashboard. 

You will then able able to login with admin permissions with:

* **Username:** ``admin``{{copy}}
* **Password:** ``admin``{{copy}}

Or as a standard user with:

* **Username:** ``developer``{{copy}}
* **Password:** ``developer``{{copy}}

## Logging in to the Cluster via CLI

When the OpenShift playground is created you will be logged in initially as
a cluster admin (`oc whoami`{{execute}}) on the command line. This will allow you to perform
operations which would normally be performed by a cluster admin.

Before creating any applications, it is recommended you login as a distinct
user. This will be required if you want to log in to the web console and
use it.

To login to the OpenShift cluster from the _Terminal_ run:

``oc login -u developer -p developer``{{execute}}

This will log you in using the credentials:

* **Username:** ``developer``
* **Password:** ``developer``

Use the same credentials to log into the web console.

In order that you can still run commands from the command line as a cluster
admin, the ``sudoer`` role has been enabled for the ``developer`` account.
To execute a command as a cluster admin use the ``--as system:admin`` option
to the command. For example:

``oc get projects --as system:admin``{{execute}}

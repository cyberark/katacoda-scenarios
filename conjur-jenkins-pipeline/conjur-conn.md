
The following steps define the connection to the DAP appliance. This is typically a one-time configuration.

1. Navigate to Jenkins > Credentials > System > [Global credentials (unrestricted)](https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com//credentials/store/system/domain/_/newCredentials)

2. On the form that appears, configure the login credentials. These are credentials for the Jenkins host to log into DAP.

![theimage](https://github.com/quincycheng/katacoda-scenarios/raw/master/conjur-jenkins/media/04-conn.PNG)

 - Username: ``host/jenkins-frontend/frontend-01`{{copy}}
 - Password: 

  Copy and paste the API key that was returned by DAP when you loaded the policy declaring this host.
  Forgot it?  No worries, execute `cat frontend.out`{{execute}} to review it

3. Click Save.

You can also decide whether to set up global or folder-level access to DAP, or a combination of both.

To learn more, visit [CyberArk Conjur Doc](https://docs.conjur.org/Latest/en/Content/Integrations/jenkins-configure.htm?tocpath=Integrations%7CJenkins%7C_____2#ConfigureJenkinsConjurconnection)


4. Navigate to either Jenkins > Manage Jenkins > [Configure System](https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com/configure)

5. Scroll down to "Conjur Appliance"

6. Fill in the form

- Account: `quick-start`{{copy}}
- Appliance URL: https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com
- Conjur Authn Credential: `host/jenkins-frontend/frontend-01/*****`{{copy}}


7. Click Save

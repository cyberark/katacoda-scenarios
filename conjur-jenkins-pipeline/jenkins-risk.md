
It works well, right?   Jenkins even [conseal the credentials](https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com/job/Demo/credentials/store/folder/domain/_/credential/theServerAccount/update)


![theimage](https://github.com/quincycheng/katacoda-scenarios/raw/master/conjur-jenkins/media/02-jenkins_demo_cred_details.PNG)


Think about your environment, where you have various systems and zones, not to mention dev, staging, UAT & production sites.
And don't forget your on-premise and cloud environments.

- How will you change the secrets of various environments?
- How do you make sure the process is secure?
- How do you change all the secrets when security incident happens?
- How do you know who or what systems has access to the secrets?
- Do you have the visibility on them when they access the secrets?


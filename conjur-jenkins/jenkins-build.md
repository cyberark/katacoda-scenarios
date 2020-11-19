
Let's build the project and make sure it's working

1. Click on ["Typical Freestyle project"](https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com/job/Demo/job/Typical%20Freestyle%20Project/) to go back the project page 
   ![theimage](https://github.com/quincycheng/katacoda-scenarios/raw/master/conjur-jenkins/media/02-jenkins_typical_freestyle.PNG)

2. Click "Build Now" on the left.   After a moment, a new build history will be shown

   ![theimage](https://github.com/quincycheng/katacoda-scenarios/raw/master/conjur-jenkins/media/02-jenkins_typical_freestyle_build.PNG)

3. Click on the new build number under "build" & choose "Console Output" on the left menu

   ![theimage](https://github.com/quincycheng/katacoda-scenarios/raw/master/conjur-jenkins/media/02-jenkins_typical_freestyle_console.PNG)

4. `Response Code: HTTP/1.0 200 OK` & `Finished: SUCCESS` should be shown in the page.
   Meaning that Jenkins has successfully connect to the target web app with authnication successfully.


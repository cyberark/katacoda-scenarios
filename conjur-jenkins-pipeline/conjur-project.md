Let's test the setup by creating a new project

1. To create a new project, go to Demo & click ["New Item"](https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com/

Enter an item name: Secure Pipeline Project
Type: Freestyle Project

![theimage](https://github.com/quincycheng/katacoda-scenarios/raw/master/conjur-jenkins/media/xxx.PNG)

2. Click OK

3. Next, we need to add a new binding.   Check "Use secret text(s) or files(s) under "Build Triggers"

4. click "Add" > "Conjur Secret Credentials"

- Variable : WEB_PASSWORD
- Credentials > Specific credentials: "ConjurSecret:jenkins-app/web_password/*Conjur*()"

5. Click "Build" tab at the top

6. Click "Add build step" > "Execute a shell"

Command:  curl http://theServerAccount:$CONJUR_SECRET@http-auth-server

7. Click Save

8. Let's verify the setup by clicking Build Now 

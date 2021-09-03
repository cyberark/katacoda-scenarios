Let's test the setup by copying & updating the project

1. To create a new project, go to Demo & click ["New Item"](https://[[HOST_SUBDOMAIN]]-8081-[[KATACODA_HOST]].environments.katacoda.com/job/Demo/newJob)

 - Enter an item name: `Secure Freestyle Project`{{copy}}
 - Type: `Freestyle Project`

2. Click OK

3. Next, we need to add a new binding.   
   Check "Use secret text(s) or files(s) under "Build Environment"

4. Under Binding, click "Add" > "Conjur Secret Credentials"

- Variable : `WEB_PASSWORD`{{copy}}
- Credentials > Specific credentials: "ConjurSecret:jenkins-app/web_password/*Conjur*()"

5. Click "Build" tab at the top

6. Click "Add build step" > "Execute shell"

   Command:  `curl -Is -u theServerAccount:$CONJUR_SECRET http://http-auth-server`{{copy}}

7. Click Save

8. Let's verify the setup by clicking Build Now 

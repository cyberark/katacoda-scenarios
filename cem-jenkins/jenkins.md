
Jenkins UI: https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/

# Steps
1. Create an API Key from CEM at https://cem.cyberark.com/integrations/api-keys
2. Open `CEM Demo` pipeline at https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/job/CEM%20Demo/
3. Click `Build Now` to execute the pipeline
4. When the progress paused at `Check CEM Settings` step, click on it and fill in the user prompts, as shown in the above screen capture, and click `Proceed`
   (You can also update the pipeline or Jenkins settings to set `CEM_ORG` & `CEM_APIKEY` environment variables to avoid this prompt)
5. Hover to each of the steps and click `Logs` to review the output, and [sample pipeline](https://github.com/quincycheng/cem-jenkins-lib/blob/main/example/Jenkinsfile)

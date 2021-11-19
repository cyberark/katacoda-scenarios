
Now let's test the app again


## Get the URL

To check whether the app is started & get the endpoint of the service, execute:
```

export URL=$(oc get route testapp-secure -o jsonpath='{.spec.host}'  ) && \
curl $URL/pets
```{{execute}}

If a `curl` error is returned, that means the application is still being started.
Please wait for a couple of moments and try again

## Test the app

To add a new message with a random name, execute:
`curl  -d "{\"name\": \"$(shuf -n 1 /usr/share/dict/words)\"}" -H "Content-Type: application/json" $URL/pet`{{execute}}

Now let's list all the messages by executing:
`curl -s $URL/pets | jq .`{{execute}}

You can repeat the above actions to create & review multiple messages.

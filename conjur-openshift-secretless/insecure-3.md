When we deploy the application, the database secret is embedded in the configuration

`cat insecure/app.yml`{{execute}}

Can you find it? It's at the end of the configuration.
```
          - name: DB_USERNAME
            value: test_app
          - name: DB_PASSWORD
            value: 5b3e5f75cb3cdc725fe40318
```

Who has reviewed it?
When did it happen?
Can you track it?

Yup, that's the risk we're talking about.

Let's fix it!

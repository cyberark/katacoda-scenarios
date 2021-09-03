We will model a simple application in which a frontend service connects to a db server. The db policy defines a password, which the frontend application uses to log in to the database.

Here is a skeleton policy for this scenario, which simply defines two empty policies: db and frontend. Save this policy as “conjur.yml”:

<pre class="file" data-filename="conjur.yml" data-target="replace">- !policy
  id: db

- !policy
  id: frontend
</pre>

Note: You can create this file, either by clicking above "Copy to Editor" or executing `cp /root/conjur.bak /root/conjur.yml`{{execute}}

Then load it using the following commands:

```
docker cp /root/conjur.yml conjur_client:conjur.yml
docker-compose exec client conjur policy load --replace root conjur.yml
```{{execute}}

```
Loaded policy 'root'
{
  "created_roles": {
  },
  "version": 1
}
```


Use the conjur list command to view all the objects in the system:

`docker-compose exec client conjur list`{{execute}}

```
[
  "quick-start:policy:root",
  "quick-start:policy:db",
  "quick-start:policy:frontend"
]
```


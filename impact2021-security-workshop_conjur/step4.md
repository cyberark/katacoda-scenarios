Having defined the policy framework, we can load the specific data for the database.

Create the following file as “db.yml”:

Declare the secrets which are used to access the database:
<pre class="file" data-filename="db.yml" data-target="replace">- &variables
  - !variable password
</pre>

Define a group which will be able to fetch the secrets:
<pre class="file" data-filename="db.yml">
- !group secrets-users
</pre>

`read` privilege allows the client to read metadata.
`execute` privilege allows the client to read the secret data.
These are normally granted together, but they are distinct just like read and execute bits on a filesystem.

<pre class="file" data-filename="db.yml">
- !permit
  resource: *variables
  privileges: [ read, execute ]
  roles: !group secrets-users
</pre>


Note: You can create this file, either by clicking above "Copy to Editor" or executing `cp /root/db1.bak /root/db.yml`{{execute}}

Now load it using the following command:

```
docker cp /root/db.yml conjur_client:db.yml
docker-compose exec client conjur policy load db db.yml
```{{execute}}

```
Loaded policy 'db'
{
  "created_roles": {
  },
  "version": 1
}
```

The variable `db/password` has been created, but it doesn’t contain any data. So the next step is to load the password value:

```
password=$(openssl rand -hex 12)
echo $password
```{{execute}}

`ac8932bccf835a5a13586100`

`docker-compose exec client conjur variable values add db/password $password`{{execute}}

`Value added`

`docker-compose exec client conjur variable value db/password`{{execute}}

`ac8932bccf835a5a13586100`

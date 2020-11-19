Let’s verify everything works as expected.

First, make sure the `APPLICATION_URL` is correctly set:

`export APPLICATION_URL=[[HOST_IP]]:30002`{{execute}}

Now let’s create a pet (POST /pet):

```
curl -i -d @- \
 -H "Content-Type: application/json" \
 ${APPLICATION_URL}/pet \
 << EOF
{
   "name": "Secretlessly Fluffy"
}
EOF
```{{execute}}

```
HTTP/1.1 201
Location: http://192.168.99.100:30002/pet/2
Content-Length: 0
Date: Thu, 23 Aug 2019 11:56:27 GMT
```

We should get a 201 response status.

Now let’s retrieve all the pets (GET /pets):

`curl -i ${APPLICATION_URL}/pets`{{execute}}

```
HTTP/1.1 200
Content-Type: application/json;charset=UTF-8
Transfer-Encoding: chunked
Date: Thu, 23 Aug 2018 11:57:17 GMT

[{"id":1,"name":"Secretlessly Fluffy"}]
```

We should get a 200 response with a JSON array of the pets.

That’s it!

The application is connecting to a password-protected Postgres database without any knowledge of the credentials.

![It's Magic](https://secretless.io/img/its_magic.jpg)
For more info on configuring Secretless for your own use case, see the [Secretless Documentation](https://docs.secretless.io/Latest/en/Content/Overview/how_it_works.htm)

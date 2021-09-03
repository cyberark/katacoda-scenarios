
We're going to create a simple PHP webpage that connects to a MySQL database to query and present a message stored in the `conjur_demo` database's `demo` table.

First, we'll create a file inside the `/opt/app` directory. Any file that is located within that directory will be hosted by the LAMP container's Apache service. Luckily, the VS Code instance we'll be using is already set to `/opt/app` as the root directory.

`touch /opt/app/insecure.php`{{execute}}

Next, we'll need to authenticate & connect to the MySQL database. Since we don't have access to a secret management service, we'll need to hard code the connection secrets.

<pre class="file" data-filename="insecure.php" data-target="replace">&lt;?php
$connection = new PDO('mysql:host=localhost;dbname=conjur_demo', 'devapp1', 'Cyberark1');
</pre>

Now that we have our authenticated connection to the MySQL database, we need to send over our query.

<pre class="file" data-filename="insecure.php" data-target="append">
$statement = $connection->query('SELECT message FROM demo');
</pre>

If all went well, we can now add an `echo` statement to display what the value was of `message`.

<pre class="file" data-filename="insecure.php" data-target="append">
echo $statement->fetchColumn();
?&gt;
</pre>

Let's see if it worked!

Click the "Web App" tab next to "Terminal" and append `/insecure.php` to the URL, or click [https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/insecure.php](https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/insecure.php) to view the webpage.

If successful, it should read:

```
If you are seeing this message, we have successfully connected PHP to our backend MySQL database!
```

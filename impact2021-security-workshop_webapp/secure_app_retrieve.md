
Now that we've authenticated and received our session token, it's time to use it to retrieve the secrets we need for our MySQL database connection. We'll need to modify a few of the curl options for the retrieval request. First, let's retrieve the the database username.

<pre class="file" data-filename="secure.php" data-target="append">
&lt;?php
$headr = array();
$headr[] = 'Authorization: Token token="' . $sessionToken . '"';
curl_setopt($curl, CURLOPT_HTTPHEADER, $headr);

curl_setopt($curl, CURLOPT_URL, 'http://conjur/secrets/quick-start/variable/devapp%2Fdb_uname');
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, 'GET');
$db_username = curl_exec($curl);
echo 'The database username: ' . $db_username . '&lt;br/&gt;';
?&gt;
</pre>

If you view the Web App, you should now see the Conjur API Session Token and the database username reported now.

Let's retrieve the database password next. Since most of the curl options were set last time, we only need to update the URL.

<pre class="file" data-filename="secure.php" data-target="append">
&lt;?php
curl_setopt($curl, CURLOPT_URL, 'http://conjur/secrets/quick-start/variable/devapp%2Fdb_pass');
$db_password = curl_exec($curl);
echo 'The database password: ' . $db_password . '&lt;br/&gt;';
?&gt;
</pre>

If you view the Web App, you should now see the Conjur API Session Token, the database username and now the database password, as well.

The final piece to this PHP puzzle is authenticating to MySQL and displaying our message. We'll use the two variables holding the values we need to accomplish this.

<pre class="file" data-filename="secure.php" data-target="append">
&lt;?php
$connection = new PDO('mysql:host=localhost;dbname=conjur_demo', $db_username, $db_password);
$statement = $connection->query('SELECT message FROM demo');
echo $statement->fetchColumn();
echo '&lt;br/&gt;';
?&gt;
</pre>

Switching and refreshing or clicking the Web App tab should now display everything from before along with our database message. Alternatively, you can click the link again to see it refreshed at [https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/secure.php](https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/secure.php).

This source code can now be committed to source control management, such as GitHub, without worry of leaking secrets!


In the last step, we did something we should **NEVER** do. We hard-coded the credentials to connect to MySQL into the source code in plain-text.

What we should be doing, instead, is making a request for the credentials as they're needed. This serves multiple security purposes:

1. Our credentials are no longer exposed anywhere in plain-text.
2. We can now introduce rotation of the credentials to stay within compliance.
3. We can audit the application retrieving the secrets for a complete audit trail.

Let's create a new webpage called `secure.php` where we'll put this technique to practice similar to how developers have to change their code.

`touch /opt/app/secure.php`{{execute}}

When this scenario was pre-configured, a policy was loaded that created an identity for our webpage to use. When the `lamp` container was run for the first time, it was injected with the identity. Now, our webpage can utilize environment variables for authentication instead of hard-coding them in plain-text within our webpage's source code.

We'll be using the `curl` method in our webpage. There are other PHP modules available for making API requests, but since this is built-in to PHP by default, we'll be using it.

Let's initialize curl in our webpage:

<pre class="file" data-filename="secure.php" data-target="replace">&lt;?php
curl_setopt(CURLOPT_RETURNTRANSFER, true);
$ch = curl_init('http://conjur/authn/quick-start/login');
curl_setopt($ch, CURLOPT_USERPWD, getenv("CONJUR_AUTHN_LOGIN").":". getenv("CONJUR_AUTHN_API_KEY"));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$refresh_token = curl_exec($ch);
curl_close($ch);

$curl = curl_init();
</pre>

Next, we need to create an array, which is a collection of variables, to set our curl options:

<pre class="file" data-filename="secure.php" data-target="append">
curl_setopt_array($curl, array(
    CURLOPT_URL => 'http://conjur/authn/quick-start/demouser/authenticate',
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_SSL_VERIFYPEER => false,
    CURLOPT_SSL_VERIFYHOST => false,
    CURLOPT_POSTFIELDS =>$refresh_token,
    CURLOPT_HTTPHEADER => array(
        'Accept-Encoding: base64',
        'Content-Type: application/json'
    ),
));
</pre>

Above, you will notice two environment variables being referenced.

* `getenv("CONJUR_AUTHN_LOGIN")`
* `getenv("CONJUR_AUTHN_API_KEY")`

Now that we've initialized curl and set our curl options, we need to execute curl to send the request and receive a response from the Conjur API.

<pre class="file" data-filename="secure.php" data-target="append">
$sessionToken = curl_exec($curl);
</pre>

The variable `$sessionToken` should now contain our Conjur API Session Token. To check this, for the purpose of this scenario, we'll `echo` it out for us to view.

<pre class="file" data-filename="secure.php" data-target="append">
echo 'Conjur API Session Token: ' . $sessionToken . '<br />';
?&gt;
</pre>

Click the "Web App" tab next to "Terminal" and append `/secure.php` to the URL, or click [https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/secure.php](https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/secure.php) and check out the results!

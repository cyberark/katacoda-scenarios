We will now create a user principle and corresponding keytab file.

### Create a new User Principle

`kadmin`{{execute}}

Password: `5b1d328bc88b97356f406fab456b5a99`{{execute}}

kadmin: `ank -policy users quincy`{{execute}}

Enter password for principal "quincy@CYBERARKDEMO.COM": `d02742206e656fbaa1d33d11b104bb4f`{{execute}}

Re-enter password for principal "quincy@CYBERARKDEMO.COM": `d02742206e656fbaa1d33d11b104bb4f`{{execute}}

Principal "quincy@CYBERARKDEMO.COM" created`

kadmin: `quit`{{execute}}

### Create a keytab file

`ktutil`{{execute}}

ktutil: `addent -password -p quincy@CYBERARKDEMO.COM -k 1 -e aes256-cts-hmac-sha1-96`{{execute}}

ktutil: Password for quincy@CYBERARKDEMO.COM: `d02742206e656fbaa1d33d11b104bb4f`{{execute}}

ktutil: `wkt user.keytab`{{execute}}

ktutil: `quit`{{execute}}

### Verify the keytab file

Let's try to logon to KDC using the newly created keytab file.  No errors should be shown.

`kinit quincy@CYBERARKDEMO.COM -k -t user.keytab`{{execute}}

Execute some commands to verify the default principal:

`klist`{{execute}}



In this scenario, we will be working with a Linux, Apache, MySQL and PHP (LAMP) stack.

# Problem
In order for a PHP webapp to connect to MySQL, it will require a username and password for the connection string.

# Solution
We will use CyberArk Conjur Secrets Manager to provide secrets just-in-time to the web application to provide easy management and secure coding within the app.

# Agenda
1. We will create a PHP file that connects to MySQL to retrieve and display data using hard-coded credentials in the connection string.
2. We will then modify the PHP file to remove the hard-coded credentials and retrieve them instead from CyberArk Conjur when needed.
3. We will change the password for the MySQL user in the database and in CyberArk Conjur.
4. Finally, we will browse back to the PHP website to see that no code changes are required further.